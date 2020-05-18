defmodule Spur.Activity do
  use Ecto.Schema

  import Ecto.Changeset

  alias Spur.Activity

  schema "activities" do
    field(:action, :string)
    field(:actor, :string)
    field(:object, :string, default: nil)
    field(:target, :string, default: nil)
    field(:meta, :map, default: %{})

    timestamps(updated_at: false)
  end

  def changeset(%Activity{} = trace, %{} = attrs) do
    trace
    |> cast(attrs, [:action, :actor, :object, :target, :meta])
    |> validate_required([:action, :actor])
  end
end
