defmodule ChatApp.Repo.Migrations.CreateUserRooms do
  use Ecto.Migration

  def change do
    create table(:user_rooms) do
      add :user_id, references(:users), null: false
      add :room_id, references(:rooms), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_rooms, [:user_id])
    create index(:user_rooms, [:room_id])

    create unique_index(:user_rooms, [:user_id, :room_id], name: :user_rooms_user_id_room_id)
  end
end
