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
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sentient_social_web, :generators, context_app: :sentient_social

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
