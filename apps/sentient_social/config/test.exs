use Mix.Config

# Configure your database
config :sentient_social, SentientSocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sentient_social_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :cloak, Cloak.AES.GCM,
  default: true,
  tag: "GCM",
  keys: [
    %{
      tag: <<1>>,
      key: Base.decode64!("lMJpRrFo4m9dGhKcGXywBFtqMQGhY8FpDevwB3NMIXo="),
      default: true
    }
  ]

config :sentient_social, twitter_client: SentientSocial.Twitter.MockTwitterClient
config :sentient_social, rate_limiter: SentientSocial.Twitter.MockRateLimiter
