defmodule SpurTest.Repo.Migrations.AddActivities do
  use Ecto.Migration

  def change do
    create table(:activity) do
      add(:action, :string, null: false)
      add(:actor, :string)
      add(:object, :string)
      add(:meta, :map)
      add(:target, :string)

      timestamps(updated_at: false)
    end
  end
end
