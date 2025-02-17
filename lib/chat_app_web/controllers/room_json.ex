defmodule ChatAppWeb.RoomJSON do
  def room(%{room: room}) do
    %{
      id: room.id,
      name: room.name
    }
  end
end
