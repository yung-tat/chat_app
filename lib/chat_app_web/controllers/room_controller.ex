defmodule ChatAppWeb.RoomController do
  alias ChatApp.UserRooms
  alias ChatApp.RoomSupervisor
  alias ChatApp.Rooms
  use ChatAppWeb, :controller

  @salt "replace-user-salt"

  plug :assign_user_id

  def create(conn, %{"name" => name}) do
    with {:ok, room} <- Rooms.create_room(name),
         {:ok, _} <- UserRooms.add_user_to_room(conn.assigns.user_id, room.id) do
      RoomSupervisor.start_room(room.id)
      render(conn, :room, room: room)
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

  defp assign_user_id(conn, _) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- Phoenix.Token.verify(ChatAppWeb.Endpoint, @salt, token, max_age: 1_209_600) do
      assign(conn, :user_id, user_id)
    else
      _ ->
        conn
        |> send_resp(400, "User token required for room actions")
        |> halt()
    end
  end
end
