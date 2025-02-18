defmodule ChatApp.AppSetup do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(:ok) do
    rooms_started =
      ChatApp.Rooms.get_all_rooms()
      |> Enum.map(fn room -> ChatApp.RoomSupervisor.start_room(room.id) end)
      |> Enum.filter(fn
        {:ok, _} -> true
        _ -> false
      end)
      |> length()

    IO.inspect("Started #{rooms_started} room(s)")
    {:ok, :ok}
  end
end
