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
  secret_key_base: "2X9Z44LuMH/9+DVzIMft4n3phl8/++3W2Q1YP84VjA//RpaiZAyTyv/Zx7I9WXkk",
  render_errors: [view: SentientSocialWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SentientSocial.PubSub,
  live_view: [signing_salt: "A1/nm/3s"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# ExTwitter (keys from https://developer.twitter.com/ with personal account)
access_token =
  System.get_env("PERSONAL_ACCESS_TOKEN") ||
    raise("expected the PERSONAL_ACCESS_TOKEN environment variable to be set")

access_token_secret =
  System.get_env("PERSONAL_ACCESS_SECRET") ||
    raise("expected the PERSONAL_ACCESS_SECRET environment variable to be set")

consumer_key =
  System.get_env("PERSONAL_CONSUMER_KEY") ||
    raise("expected the PERSONAL_CONSUMER_KEY environment variable to be set")

consumer_secret =
  System.get_env("PERSONAL_CONSUMER_SECRET") ||
    raise("expected the PERSONAL_CONSUMER_SECRET environment variable to be set")

config :extwitter, :oauth,
  consumer_key: consumer_key,
  consumer_secret: consumer_secret,
  access_token: access_token,
  access_token_secret: access_token_secret

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
