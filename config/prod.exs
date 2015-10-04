use Mix.Config

config :black_book, BlackBook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine",
  username: "rob"

config :logger, level: :error
