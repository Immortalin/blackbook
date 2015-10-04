use Mix.Config
config :blackbook, Blackbook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine_test",
  username: "rob"

config :logger, level: :error
