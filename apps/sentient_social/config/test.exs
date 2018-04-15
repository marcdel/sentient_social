use Mix.Config

# Configure your database
config :sentient_social, SentientSocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sentient_social_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :sentient_social, twitter_client: SentientSocial.Twitter.MockTwitterClient
