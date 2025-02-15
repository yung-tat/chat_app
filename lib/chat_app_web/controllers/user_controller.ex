defmodule ChatAppWeb.UserController do
  use ChatAppWeb, :controller

  alias ChatApp.Accounts
  alias ChatApp.Schemas.User

  action_fallback ChatAppWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end
end
