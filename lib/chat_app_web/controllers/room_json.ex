defmodule ChatAppWeb.RoomJSON do
  def room(%{room: room}) do
    %{
      id: room.id,
      name: room.name
    }
  end

  def invite_code(%{code: code}) do
    %{invite_code: code}
  end
end
