defmodule ChatApp.Schemas.Room do
  use ChatApp.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
