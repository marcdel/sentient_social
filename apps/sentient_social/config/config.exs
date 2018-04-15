use Mix.Config

config :sentient_social, ecto_repos: [SentientSocial.Repo]

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")

config :sentient_social, twitter_client: SentientSocial.Twitter.ExTwitterClient

import_config "#{Mix.env()}.exs"
