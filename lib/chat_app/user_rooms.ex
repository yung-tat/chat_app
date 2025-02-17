defmodule ChatApp.UserRooms do
  import Ecto.Query, warn: false
  alias ChatApp.Schemas.UserRoom
  alias ChatApp.Repo

  def is_user_authorized?(user_id, room_id), do: not is_nil(get_user_room(user_id, room_id))

  def get_user_room(user_id, room_id) do
    UserRoom.query()
    |> where([user_room: ur], ur.user_id == ^user_id and ur.room_id == ^room_id)
    |> Repo.one()
  end

  def add_user_to_room(user_id, room_id) do
    %UserRoom{}
    |> UserRoom.changeset(%{user_id: user_id, room_id: room_id})
    |> Repo.insert()
  end
end
