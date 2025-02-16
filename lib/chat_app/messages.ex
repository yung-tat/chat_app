defmodule ChatApp.Messages do
  import Ecto.Query, warn: false
  alias ChatApp.Schemas.Message
  alias ChatApp.Repo

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_messages_by_room(room_id) do
    Message.query()
    |> where([message: m], m.room_id == ^room_id)
    |> order_by([asc: :inserted_at])
    |> Repo.all()
  end
end
