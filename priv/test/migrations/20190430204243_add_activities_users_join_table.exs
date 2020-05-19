defmodule SpurTest.Repo.Migrations.AddActivitiesUsersJoinTable do
  use Ecto.Migration

  def change do
    create table(:activities_users) do
      add(:activity_id, references(:activities))
      add(:user_id, references(:app_users))
    end
  end
end
