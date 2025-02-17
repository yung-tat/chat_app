defmodule ChatApp.Schemas.UserRoom do
  use ChatApp.Schema
  import Ecto.Changeset

  schema "user_rooms" do
    belongs_to :user, ChatApp.Schemas.User
    belongs_to :room, ChatApp.Schemas.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_rooms, attrs) do
    user_rooms
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint([:user_id, :room_id], name: :user_rooms_user_id_room_id)
  end

  def query, do: from(UserRoom, as: :user_room)
end
