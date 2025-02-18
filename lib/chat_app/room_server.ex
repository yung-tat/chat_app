defmodule ChatApp.RoomServer do
  alias ChatApp.Accounts
  use GenServer

  # TODO: Use ets cache for invite code

  @invite_timeout 1_000 * 60 * 25

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

  def leave_user(room_id, user_id) do
    case Accounts.get_user_by_id(user_id) do
      nil ->
        {:error, "User not found"}

      user ->
        GenServer.call(via_tuple(room_id), {:user_left, user})
    end
  end

  def get_room_info(room_id) do
    GenServer.call(via_tuple(room_id), :get_info)
  end

  def set_room_invite_code(room_id, invite_code) do
    GenServer.cast(via_tuple(room_id), {:set_invite_code, invite_code, room_id})
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

  @impl true
  def handle_cast({:set_invite_code, invite_code, room_id}, state) do
    new_state = Map.put(state, :invite_code, invite_code)
    Process.send_after(self(), {:remove_invite_code, room_id}, @invite_timeout)
    {:noreply, new_state}
  end

  @impl true
  def handle_info({:remove_invite_code, room_id}, state) do
    :ets.delete(:invite_code_registry, room_id)
    :ets.delete(:invite_code_reverse_registry, state.invite_code)
    new_state = Map.put(state, :invite_code, nil)
    {:noreply, new_state}
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
