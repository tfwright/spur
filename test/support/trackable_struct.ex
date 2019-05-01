defmodule SpurTest.TrackableStruct do
  use Ecto.Schema

  import Ecto.Changeset

  schema "trackable_structs" do
    belongs_to :user, SpurTest.AppUser

    timestamps()
  end

  defimpl Spur.Trackable, for: SpurTest.TrackableStruct do
    def actor(trackable_struct), do: "#{trackable_struct.user_id}"
    def object(trackable_struct), do: "TrackableStruct:#{trackable_struct.id}"
    def target(trackable_struct), do: nil
  end
end
