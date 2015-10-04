use Mix.Config

config :black_book, BlackBook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine_dev",
  username: "rob"

config :logger, level: :error
