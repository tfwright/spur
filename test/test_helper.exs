{:ok, _pid} = SpurTest.Repo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(SpurTest.Repo, :manual)

ExUnit.start()
