use Mix.Config

config :sentient_social, ecto_repos: [SentientSocial.Repo]

import_config "#{Mix.env()}.exs"
