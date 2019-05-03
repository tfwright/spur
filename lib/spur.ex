defmodule Spur do
  @moduledoc """
  Simple activity tracking for Ecto-backed Elixir apps.
  """

  alias Spur.{Activity, Trackable}

  alias Ecto.{Multi}

  @doc """
  Inserts the given Struct and an `Spur.Activity` record.

  ## Examples

      iex> result = Spur.insert(%SpurTest.TrackableStruct{user: %SpurTest.AppUser{}})
      ...> with {:ok, %SpurTest.TrackableStruct{}} <- result, do: :ok
      :ok

      iex> result = Spur.insert(%SpurTest.TrackableStruct{})
      ...> with {:error, %Ecto.Changeset{}} <- result, do: :error
      :error
  """
  def insert(trackable, func_or_params \\ %{}), do: track_with_callback(:insert, trackable, func_or_params)

  @doc """
  Updates the given Struct and an `Spur.Activity` record.

  ## Examples

      iex> trackable = %SpurTest.TrackableStruct{user: %SpurTest.AppUser{}} |> SpurTest.Repo.insert! |> Ecto.Changeset.change
      ...> result = Spur.update(trackable)
      ...> with {:ok, %SpurTest.TrackableStruct{}} <- result, do: :ok
      :ok
  """
  def update(trackable, func_or_params \\ %{}), do: track_with_callback(:update, trackable, func_or_params)

  @doc """
  Deletes the given Struct and an `Spur.Activity` record.

  ## Examples

      iex> trackable = %SpurTest.TrackableStruct{user: %SpurTest.AppUser{}} |> SpurTest.Repo.insert!
      ...> result = Spur.delete(trackable)
      ...> with {:ok, %SpurTest.TrackableStruct{}} <- result, do: :ok
      :ok
  """
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
