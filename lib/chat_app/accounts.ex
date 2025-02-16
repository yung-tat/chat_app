defmodule ChatApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ChatApp.Repo

  alias ChatApp.Schemas.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(name, password) do
    User.query()
    |> where([user: u], u.name == ^name and u.password == ^password)
    |> Repo.one()
  end

  def user_exists?(user), do: not is_nil(Repo.get(User, user.id))
end
