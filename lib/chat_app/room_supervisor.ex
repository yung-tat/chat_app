defmodule ChatApp.RoomSupervisor do
  use DynamicSupervisor

  alias ChatApp.RoomServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_room(room_id) do
    child_spec = %{
      id: RoomServer,
      start: {RoomServer, :start_link, [room_id]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def close_room(room_id) do
    pid = RoomServer.room_pid(room_id)
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end
