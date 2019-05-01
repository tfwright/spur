defmodule Spur do
  @moduledoc """
  <<Someone who finds a trace [Spur] certainly also knows that something has existed
  before and is now left behind. But one does not just take note of this.
  One begins to search and to ask oneself where it leads.>> HGG, "Hermeneutik auf dem Spur"
  """

  alias Spur.{Activity, Trackable}

  alias Ecto.{Multi}

  def insert(trackable, func_or_params \\ %{}), do: track_with_callback(:insert, trackable, func_or_params)
  def update(trackable, func_or_params \\ %{}), do: track_with_callback(:update, trackable, func_or_params)
  def delete(trackable, func_or_params \\ %{}), do: track_with_callback(:delete, trackable, func_or_params)

  defp track_with_callback(action, trackable, func_or_params) do
    Kernel.apply(Multi, action, [Multi.new, :trackable, trackable])
    |> Multi.insert(:activity, fn %{trackable: trackable} -> changeset_for_action(trackable, action, func_or_params) end)
    |> repo().transaction
    |> case do
      {:ok, %{trackable: trackable}} -> {:ok, trackable}
      {:error, _change, changeset, _multi} -> {:error, changeset}
    end
  end

  defp changeset_for_action(trackable, action, func_or_params) do
    %Activity{
      action: Atom.to_string(action),
      actor: Trackable.actor(trackable),
      object: Trackable.object(trackable),
      target: Trackable.target(trackable)
    }
    |> Activity.changeset(func_or_params |> extract_params(trackable))
  end

  defp extract_params(%{} = params, _obj), do: params
  defp extract_params(func, trackable) when is_function(func), do: func.(trackable, %{})

  defp repo do
    Application.fetch_env!(:spur, :repo)
  end
end
