defmodule SpurTest do
  use ExUnit.Case

  doctest Spur

  alias SpurTest.{Repo, TrackableStruct, AppUser}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "insert/1" do
    test "reponds with ok status" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user}

      assert {:ok, _trackable} = Spur.insert(test_trackable)
    end

    test "inserts the object" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user}

      {:ok, _trackable} = Spur.insert(test_trackable)

      assert 1 = TrackableStruct |> Repo.aggregate(:count, :id)
    end

    test "accepts params for activity" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user}

      assert {:error, _trackable} = Spur.insert(test_trackable, %{actor: nil})
    end

    test "accepts function that returns params for activity" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user}

      assert {:error, _trackable} = Spur.insert(test_trackable, fn _, p -> Map.merge(p, %{actor: nil}) end)
    end

    test "returns the object" do
      test_trackable = %TrackableStruct{}

      assert {_status, test_trackable} = Spur.insert(test_trackable)
    end

    test "inserts the trace" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user}

      {:ok, test_trackable} = Spur.insert(test_trackable)

      assert 1 = Spur.Activity |> Repo.aggregate(:count, :id)
    end
  end

  describe "update/1" do
    test "reponds with ok status" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      changeset = Ecto.Changeset.change(test_trackable)

      assert {:ok, _trackable} = Spur.update(changeset)
    end

    test "returns the object" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      changeset = Ecto.Changeset.change(test_trackable)

      assert {_status, test_trackable} = Spur.update(changeset)
    end

    test "inserts the trace" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      changeset = Ecto.Changeset.change(test_trackable)

      {:ok, test_trackable} = Spur.update(changeset)

      assert 1 = Spur.Activity |> Repo.aggregate(:count, :id)
    end
  end

  describe "delete/1" do
    test "reponds with ok status" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      assert {:ok, _trackable} = Spur.delete(test_trackable)
    end

    test "deletes the object" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      assert {:ok, _trackable} = Spur.delete(test_trackable)

      assert 0 = TrackableStruct |>  Repo.aggregate(:count, :id)
    end

    test "returns the object" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      assert {_status, test_trackable} = Spur.delete(test_trackable)
    end

    test "inserts the trace" do
      user = Repo.insert!(%AppUser{})
      test_trackable = %TrackableStruct{user: user} |> Repo.insert!

      {:ok, test_trackable} = Spur.delete(test_trackable)

      assert 1 = Spur.Activity |> Repo.aggregate(:count, :id)
    end
  end
end
