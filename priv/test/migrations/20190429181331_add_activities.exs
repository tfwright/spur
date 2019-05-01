defmodule SpurTest.Repo.Migrations.AddActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :action, :string, null: false
      add :actor, :string
      add :object, :string
      add :meta, :map

      timestamps(updated_at: false)
    end
  end
end
