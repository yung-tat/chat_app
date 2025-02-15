defmodule ChatApp.Schemas.UserRooms do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_rooms" do
    belongs_to :user, ChatApp.Schemas.User
    belongs_to :room, ChatApp.Schemas.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_rooms, attrs) do
    user_rooms
    |> cast(attrs, [])
    |> validate_required([])
  end
end
