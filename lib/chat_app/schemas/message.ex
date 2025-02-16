defmodule ChatApp.Schemas.Message do
  use ChatApp.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string

    belongs_to :user, ChatApp.Schemas.User
    belongs_to :room, ChatApp.Schemas.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
