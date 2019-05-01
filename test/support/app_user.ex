defmodule SpurTest.AppUser do
  use Ecto.Schema

  schema "app_users" do
    field :name, :string

    has_many :trackable_structs, SpurTest.TrackableStruct, foreign_key: :user_id

    many_to_many :activities, Spur.Activity, join_through: "activities_users"

    timestamps()
  end
end
