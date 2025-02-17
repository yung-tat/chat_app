defmodule ChatApp.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias ChatApp.RoomServer
  alias ChatApp.Repo

  alias ChatApp.Schemas.Room
  alias ChatApp.Schemas.User

  def get_room_by_id(room_id) do
    Repo.get(Room, room_id)
  end

  def get_rooms_by_user(user_id) do
    with user <- Repo.get(User, user_id),
         user <- Repo.preload(user, :user_rooms) do
      user.user_rooms
    end
  end

  def create_room(name) do
    %Room{}
    |> Room.changeset(%{name: name})
    |> Repo.insert()
  end

  def maybe_create_room_invite_code(room_id) do
    case :ets.lookup(:invite_code_registry, room_id) do
      [] ->
        invite_code = generate_invite_code()
        :ets.insert(:invite_code_registry, {room_id, invite_code})
        :ets.insert(:invite_code_reverse_registry, {invite_code, room_id})

        RoomServer.set_room_invite_code(room_id, invite_code)

        invite_code

      [{^room_id, invite_code}] ->
        invite_code
    end
  end

  def generate_invite_code do
    lowercase = Enum.to_list(?a..?z)
    uppercase = Enum.to_list(?A..?Z)
    candidate_code = for _ <- 1..6, into: "", do: <<Enum.random(lowercase ++ uppercase)>>

    case :ets.lookup(:invite_code_reverse_registry, candidate_code) do
      [] ->
        candidate_code

      [{^candidate_code, _}] ->
        generate_invite_code()
    end
  end
end
