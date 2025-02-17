defmodule ChatAppWeb.UserJSON do
  alias ChatApp.Schemas.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      password: user.password
    }
  end

  def token(%{token: token}) do
    %{token: token}
  end

  def rooms(%{rooms: user_rooms}) do
    %{
      data:
        Enum.map(user_rooms, fn user_room ->
          %{
            id: user_room.room.id,
            name: user_room.room.name
          }
        end)
    }
    |> IO.inspect()
  end
end
