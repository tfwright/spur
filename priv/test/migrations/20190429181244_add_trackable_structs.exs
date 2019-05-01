defmodule SpurTest.Repo.Migrations.AddTrackableStructs do
  use Ecto.Migration

  def change do
    create table(:trackable_structs) do
      add :user_id, references(:app_users)

      timestamps()
    end
  end
end
