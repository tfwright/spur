# Spur

[![Hex.pm](https://img.shields.io/hexpm/v/spur.svg)]()
![](https://github.com/tfwright/spur/workflows/CI/badge.svg)

Loosely based on https://github.com/chaps-io/public_activity, a very simple utility for quickly setting up an activity stream in your Elixir/Ecto app.

More detailed examples of configuration and usage are in the tests. See [this thread](https://elixirforum.com/t/spur-very-simple-activity-streams-for-ecto/22086?u=tfwright) for more information on the idea behind Spur and the changelog.

## Installation

Basic steps are

1. Add Spur to your application `deps`.
2. Add the following config to your application:

    ```
    config :spur, ecto_repos: [MyApp.Repo],
                  repo: MyApp.Repo
    ```
3. Generate and run a migration that adds an "activities" table to your repo (see priv/test/migrations). To use a different table name, set the `activities_table_name` config.


That's enough to start tracking arbitrary activities:

```
%Spur.Activity{actor: "caesar", action: "came", object: "your-county", meta: %{also: ["saw", "conquered"]}}
```

Fields are based on https://www.w3.org/TR/activitystreams-core/#example-1

## Getting fancy

### "Callbacks"

If you want to make use of automatic tracking of inserts, updates and deletes, make sure your objects implement the required fields as functions:

```
defmodule Battle do
  defimpl Spur.Trackable, for: __MODULE__ do
    def actor(war), do: "Accounts.User:#{war.general_id}"
    def object(war), do: "war:#{war.id}"
    def target(_war), do: nil
  end
end
```

Now instead of using `Repo` to perform your operation, use `Spur` instead:

```
%MyApp.Battle{general_id: 5}
|> MyApp.Battle.changeset
|> Spur.insert
```

In this example, a record for both your `Battle` and an `Activity` with action set to insert will be stored in the DB. Of course, the `Battle` fails validations, neither will be inserted and the changeset will be returned with errors, just as `Repo` would. Otherwise it will return the `Battle`. (*Note*: As of 0.3.0, Spur supports the `expose_transactions` config, which when sets to true returns the raw Ecto transaction. Us this if you need to access the created `Activity` struct.)

Each of these callback functions also take a `Map` of properties that will be added to the `Activity` record, or a `Function` that returns a `Map`. See the [documentation](https://hexdocs.pm/spur/Spur.html#insert/2) for examples.

### Audience

To automatically associate the `Activity` with an [audience](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-audience) requires a bit of extra configuration:

1. Add `audience_module` to your app's Spur config: `audience_module: MyApp.Accounts.User`
2. Add a `many_to_many` association between your audience module's Ecto schema. By default Spur expects this to be named `:activities`. If you want to name it something else, add another line to the config: `audience_assoc_name: :events`.
3. Finally, make sure that your trackable objects implement `audience`. It should return either an Ecto query or a plain list of the audience structs configured with the above association.

Now when you use one of the callback's above to track an object, the resulting `Activity` will automatically be associated with the audience records returned for that object:

      # SpurTest.TrackableStruct
      def audience(trackable_struct), do: Ecto.assoc(trackable_struct, :watchers)

      [watcher] = trackable_struct.watchers

      Ecto.Changeset.change(trackable_struct)
      |> Spur.update

      [%Spur.Activity{action: update}] = watcher.activities

---

> <<Someone who finds a trace [Spur] certainly also knows that something has existed before and is now left behind. But one does not just take note of this. One begins to search and to ask oneself where it leads.>>
>
> Hans Georg-Gadamer, "Hermeneutik auf dem Spur"
