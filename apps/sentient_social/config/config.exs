use Mix.Config

config :sentient_social, ecto_repos: [SentientSocial.Repo]

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

config :cloak, Cloak.AES.GCM,
  default: true,
  tag: "GCM",
  keys: [
    %{
      tag: <<1>>,
      key: {:system, "CLOAK_KEY"},
      default: true
    }
  ]

config :hammer,
  backend: {
    Hammer.Backend.ETS,
    [expiry_ms: 60_000 * 15, cleanup_interval_ms: 60_000 * 10]
  }

config :sentient_social, twitter_client: SentientSocial.Twitter.ExTwitterClient

import_config "#{Mix.env()}.exs"
