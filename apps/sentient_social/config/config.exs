use Mix.Config

config :sentient_social, ecto_repos: [SentientSocial.Repo]

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# key = Base.decode64(System.get_env("CLOAK_KEY"))
# config :sentient_social, SentientSocial.Vault,
#       ciphers: [
#         default: {Cloak.Ciphers.AES.CTR, tag: "AES.V2", key: key},
#         retired: {Cloak.Ciphers.Deprecated.AES.CTR, module_tag: "AES", tag: <<1>>, key: key}
#       ]

config :hammer,
  backend: {
    Hammer.Backend.ETS,
    [expiry_ms: 60_000 * 15, cleanup_interval_ms: 60_000 * 10]
  }

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

config :sentient_social, SentientSocial.Repo,
  loggers: [{Timber.Integrations.EctoLogger, :log, []}]

config :sentient_social, twitter_client: SentientSocial.Twitter.ExTwitterClient
config :sentient_social, rate_limiter: SentientSocial.Twitter.HammerRateLimiter

import_config "#{Mix.env()}.exs"
