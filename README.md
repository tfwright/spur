# Spur

Loosely based on https://github.com/chaps-io/public_activity, a very simple utility for quickly setting up an activity stream in your Elixir/Ecto app.

Example of configuration and usage are in the tests, but the basic steps are 

1. Add Spur to your application deps
2. Generate and run a migration that adds an activities table to your repo (see priv/test/migrations)
3. Add the following config:

    ```
    config :spur, ecto_repos: [MyApp.Repo],
                repo: MyApp.Repo
    ```
