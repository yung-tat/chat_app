defmodule ChatApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string

      add :user_id, references(:users), null: false
      add :room_id, references(:rooms), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:room_id])
  end
end
