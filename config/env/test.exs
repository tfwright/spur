use Mix.Config

config :spur, ecto_repos: [SpurTest.Repo],
              repo: SpurTest.Repo,
              audience_module: SpurTest.AppUser

config :spur, SpurTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "spur_test_repo",
  hostname: "localhost",
  poolsize: 10,
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "priv/test"
