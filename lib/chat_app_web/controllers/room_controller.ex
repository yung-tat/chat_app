defmodule ChatAppWeb.RoomController do
  alias ChatApp.RoomSupervisor
  alias ChatApp.Rooms
  use ChatAppWeb, :controller

  def create(conn, %{"name" => name}) do
    with {:ok, room} <- Rooms.create_room(name) do
      RoomSupervisor.start_room(room.id)
      send_resp(conn, :created, room.id)
    end
  end

  def create_invite_code(conn, %{"room_id" => room_id}) do
    case Rooms.get_room_by_id(room_id) do
      nil ->
        send_resp(conn, 404, "Room does not exist")

      _ ->
        invite_code = Rooms.maybe_create_room_invite_code(room_id)
        send_resp(conn, 201, invite_code)
    end
  end
end
