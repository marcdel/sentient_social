use Mix.Config

# Heroku config
# config :sentient_social, SentientSocial.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   url: System.get_env("DATABASE_URL"),
#   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
#   ssl: true

# Gigalixir config
config :sentient_social, SentientSocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  database: "",
  ssl: true,
  pool_size: 1

# import_config "prod.secret.exs"
