defmodule ChatApp.Accounts.User do
  use ChatApp.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
  end
end
