defmodule SpurTest.Repo do
  use Ecto.Repo,
    otp_app: :spur,
    adapter: Ecto.Adapters.Postgres
end
