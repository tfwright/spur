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
    |> Multi.run(:audience, fn _repo, %{trackable: trackable, activity: activity} -> associate_with_audience(audience_module(), activity, trackable) end)
    |> repo().transaction
    |> case do
      {:ok, %{trackable: trackable}} -> {:ok, trackable}
      {:error, _change, changeset, _multi} -> {:error, changeset}
    end
  end

  defp associate_with_audience(nil, _, _), do: {:ok, []}
  defp associate_with_audience(module, activity, trackable) do
    audience_assoc_reflection = module.__schema__(:association, audience_assoc_name())

    [{audience_fkey_name, audience_pkey_name}, {activity_fkey_name, activity_pkey_name}] = audience_assoc_reflection.join_keys

    audience_assocs = Trackable.audience(trackable)
    |> Enum.map(fn audience ->
      %{audience_fkey_name => extract_audience_pkey(audience, audience_pkey_name), activity_fkey_name => activity |> Map.get(activity_pkey_name)}
    end)

    {n, nil} = repo().insert_all(audience_assoc_reflection.join_through, audience_assocs)

    {:ok, n}
  end

  defp extract_audience_pkey(%{} = attrs, pkey_name), do: attrs |> Map.get(pkey_name)
  defp extract_audience_pkey(id, _pkey_name), do: id

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

  defp audience_module do
    Application.fetch_env!(:spur, :audience_module)
  end

  defp audience_assoc_name do
    Application.fetch_env!(:spur, :audience_assoc_name)
  end
end
