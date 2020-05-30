defmodule Spur.Activity do
  use Ecto.Schema

  import Ecto.Changeset

  alias Spur.Activity

  schema Application.get_env(:spur, :activities_table_name, "activities") do
    field(:action, :string)
    field(:actor, :string)
    field(:object, :string, default: nil)
    field(:target, :string, default: nil)
    field(:meta, :map, default: %{})

    with {:ok, opts} <- Application.fetch_env(:spur, :audience_assoc_options),
         [module | args] <- opts do
      many_to_many(:audience, module, args)
    end

    timestamps(updated_at: false)
  end

  def changeset(%Activity{} = trace, %{} = attrs) do
    trace
    |> cast(attrs, [:action, :actor, :object, :target, :meta])
    |> validate_required([:action, :actor])
  end
end
