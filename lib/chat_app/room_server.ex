defmodule ChatApp.RoomServer do
  alias ChatApp.Accounts
  use GenServer

  # TODO: Use ets cache for invite code

  def start_link(room_id) do
    GenServer.start_link(
      __MODULE__,
      %{
        online_users: [],
        invite_code: nil
      },
      name: via_tuple(room_id)
    )
  end

  def join_user(room_id, user_id) do
    case Accounts.get_user_by_id(user_id) do
      nil ->
        {:error, "User not found"}

      user ->
        GenServer.call(via_tuple(room_id), {:user_joined, user})
    end
  end

  def get_room_info(room_id) do
    GenServer.call(via_tuple(room_id), :get_info)
  end

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:user_joined, user}, _from, state) do
    new_state = Map.put(state, :online_users, state.online_users ++ [user])
    {:reply, new_state, new_state}
  end

  def handle_call({:user_left, user_id}, _from, state) do
    new_online_users =
      state.online_users
      |> Enum.reject(fn user -> user.id == user_id end)

    new_state = Map.put(state, :online_users, new_online_users)
    {:reply, new_state, new_state}
  end

  def handle_call(:get_info, _from, state) do
    {:reply, state, state}
  end

  def room_pid(room_id) do
    room_id
    |> via_tuple()
    |> GenServer.whereis()
  end

  defp via_tuple(room_id) do
    {:via, Registry, {ChatApp.RoomRegistry, room_id}}
  end
end
