use Mix.Config

config :blackbook, Blackbook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine",
  username: "rob"

config :logger, level: :error
