use Mix.Config

# Configure your database
config :sentient_social, SentientSocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sentient_social_dev",
  hostname: "localhost",
  pool_size: 10
