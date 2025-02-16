defmodule ChatAppWeb.UserController do
  use ChatAppWeb, :controller

  alias ChatApp.Rooms
  alias ChatApp.Accounts
  alias ChatApp.Schemas.User

  action_fallback ChatAppWeb.FallbackController

  @salt "replace-user-salt"

  def create(conn, %{"user_info" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def login(conn, %{"name" => name, "password" => password}) do
    case Accounts.get_user(name, password) do
      nil ->
        send_resp(conn, 404, "User and password combination could not be found.")

      user ->
        token = Phoenix.Token.sign(ChatAppWeb.Endpoint, @salt, user.id)

        send_resp(conn, 200, token)
    end
  end

  def get_user_rooms(conn, _params) do
    with [token] <- get_resp_header(conn, "auth-token"),
         user_id <- Phoenix.Token.verify(ChatAppWeb.Endpoint, @salt, token),
         user_rooms <- Rooms.get_rooms_by_user(user_id) do
      conn
      |> put_status(200)
      |> render(:rooms, rooms: user_rooms)
    end
  end
end
