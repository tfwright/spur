defmodule Spur.ActivityTest do
  use ExUnit.Case

  alias SpurActivity

  alias SpurTest.{Repo, AppUser}

  doctest Spur.Activity

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "requires action" do
    changeset = Spur.Activity.changeset(%Spur.Activity{}, %{})

    assert changeset.errors[:action]
  end

  test "requires actor" do
    changeset = Spur.Activity.changeset(%Spur.Activity{}, %{})

    assert changeset.errors[:actor]
  end
end
