defmodule SpurTest.TrackableStruct do
  use Ecto.Schema

  import Ecto.Changeset

  schema "trackable_structs" do
    belongs_to :user, SpurTest.AppUser

    many_to_many :watchers, SpurTest.AppUser, join_through: "app_users_trackable_structs",
                                              join_keys: [trackable_struct_id: :id, user_id: :id]

    timestamps()
  end

  defimpl Spur.Trackable, for: SpurTest.TrackableStruct do
    def actor(trackable_struct), do: "#{trackable_struct.user_id}"
    def object(trackable_struct), do: "TrackableStruct:#{trackable_struct.id}"
    def target(trackable_struct), do: nil
    def audience(trackable_struct), do: Ecto.assoc(trackable_struct, :watchers)
  end
end
