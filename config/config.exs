# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sentient_social,
  ecto_repos: [SentientSocial.Repo]

# Configures the endpoint
config :sentient_social, SentientSocialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Dv10UjgHtx3Z1Y0GS/E7m6GlzJWCmaIxo7YTKDZNVpRHx8OCMDwXheVhAcKym+YF",
  render_errors: [view: SentientSocialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SentientSocial.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")

config :sentient_social, twitter_client: TwitterClient

config :sentient_social, cloak_key: System.get_env("CLOAK_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
