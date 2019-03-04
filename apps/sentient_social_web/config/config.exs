# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sentient_social_web,
  namespace: SentientSocialWeb,
  ecto_repos: [SentientSocial.Repo]

# Configures the endpoint
config :sentient_social_web, SentientSocialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "i/VYszq5S04foHU4lytMpGG01t+crgM4qLuWBUivk+th/VcR8FIbs3beNl5a5ofl",
  render_errors: [view: SentientSocialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SentientSocialWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

config :sentry,
  dsn: "https://def3a792f10b4db7a72a36a9e45857d4@sentry.io/1223027",
  included_environments: [:prod],
  environment_name: Mix.env()

config :logger,
  backends: [Timber.LoggerBackends.HTTP],
  utc_log: true

config :timber,
  api_key:
    "3158_2617b10eb4c54ff2:c37cfbcca5217cf7fe1184b3ac2f28cf847fd162177b0a634bdc244cf5ea045e"

config :sentient_social_web, SentientSocialWeb.Endpoint,
  instrumenters: [Timber.Integrations.PhoenixInstrumenter]

config :sentient_social_web, :generators, context_app: :sentient_social

config :ueberauth, Ueberauth,
  providers: [
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

# config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
#  consumer_key: "${TWITTER_CONSUMER_KEY}",
#  consumer_secret: "${TWITTER_CONSUMER_SECRET}"

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
