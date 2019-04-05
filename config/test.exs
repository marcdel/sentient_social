use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sentient_social, SentientSocialWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sentient_social, SentientSocial.Repo,
  username: "postgres",
  password: "postgres",
  database: "sentient_social_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :phoenix_integration,
  endpoint: SentientSocialWeb.Endpoint
