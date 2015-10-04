use Mix.Config

config :blackbook, Blackbook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine_dev",
  username: "rob"

config :logger, level: :error
