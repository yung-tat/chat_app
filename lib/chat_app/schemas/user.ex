defmodule ChatApp.Schemas.User do
  use ChatApp.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string

    has_many :user_rooms, ChatApp.Schemas.UserRooms

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
  end

  def query, do: from(User, as: :user)
end
