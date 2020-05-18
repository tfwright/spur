defmodule SpurTest.Repo.Migrations.AddAppUsers do
  use Ecto.Migration

  def change do
    create table(:app_users) do
      add(:name, :string)

      timestamps()
    end
  end
end
