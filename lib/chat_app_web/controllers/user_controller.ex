defmodule ChatAppWeb.UserController do
  use ChatAppWeb, :controller

  alias ChatApp.Accounts
  alias ChatApp.Schemas.User

  action_fallback ChatAppWeb.FallbackController

  def create(conn, %{"user_info" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def log_in(conn, %{"name" => name, "password" => password}) do
    case Accounts.get_user(name, password) do
      nil ->
        send_resp(conn, 404, "User and password combination could not be found.")

      user ->
        token = Phoenix.Token.sign(ChatAppWeb.Endpoint, "replace-user-salt", user.id)

        send_resp(conn, 200, token)
    end
  end
end
