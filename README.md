# Spur

[![Hex.pm](https://img.shields.io/hexpm/v/spur.svg)]()

Loosely based on https://github.com/chaps-io/public_activity, a very simple utility for quickly setting up an activity stream in your Elixir/Ecto app.

More detailed examples of configuration and usage are in the tests.

## Installation

Basic steps are 

1. Add Spur to your application deps
2. Generate and run a migration that adds an activities table to your repo (see priv/test/migrations)
3. Add the following config:

    ```
    config :spur, ecto_repos: [MyApp.Repo],
                  repo: MyApp.Repo
    ```

That's enough to start tracking arbitrary activities.

```
%Spur.Activity{actor: "caesar", action: "came", object: "your-county", meta: %{also: ["saw", "conquered"]}}
```
    
Fields are based on https://www.w3.org/TR/activitystreams-core/#example-1

If you want to make use of automatic tracking of inserts, updates and deletes, make sure your objects implement the required fields as functions.

```
defmodule Battle do
  defimpl Spur.Trackable, for: Diddit do
    def actor(war), do: "Accounts.User:#{war.general_id}"
    def object(war), do: "war:#{war.id}"
    def target(_chore), do: nil
  end
end
```
    
Now instead of using `Repo` to perform your operation, use `Spur` instead.

```
%MyApp.Battle{general_id: 5}
|> MyApp.Battle.changeset
|> Spur.insert
```

A record for both your `Battle` and an `Activity` with action set to insert will be stored in the DB. Of course, the `Battle` fails validations, neither will be inserted and the changeset will be returned with errors, just as Repo would.
