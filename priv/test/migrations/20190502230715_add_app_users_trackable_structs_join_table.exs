defmodule SpurTest.Repo.Migrations.AddAppUsersTrackableStructsJoinTable do
  use Ecto.Migration

  def change do
    create table(:app_users_trackable_structs) do
      add(:trackable_struct_id, references(:trackable_structs))
      add(:user_id, references(:app_users))
    end
  end
end
