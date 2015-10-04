# Blackbook: A Membership System for Elixir

This is the machinery behind an authentication system and is still a bit of a work in progress. You can still do the basics (register, authenticate) and have logs that go along with each. You can tweak statuses and also login using different services if you have OAuth plumbed into your app.

This is the backing store.

## Installing

First, drop Blackbook in your dependencies:

```
[{:blackbook, ">= 0.1.0"}]
```

Next setup `config/dev.exs` (and the other environments) to tell Ecto where your DB is:

```
config :blackbook, Blackbook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine_dev",
  username: "rob"
```

Add `:blackbook` to your supervision tree to it starts up and then migrate the database:


```
mix blackbook.install
```

This will use your config settings and migrate the membership bits to the database. Once this is done, you're all set.

## Some Notes

I'm not an ORM person, and I don't particularly care for migrations. However I find that if the project is small enough that neither get in my way, so I chose to use Ecto. You'll find many things in this library are **specific to Postgres**, which is the system I built it on.

If you find any issues please let me know.

Also, this is one of my very first Elixir projects and there is likely tons of room for improvement. If you'd like to suggest changes please do!
