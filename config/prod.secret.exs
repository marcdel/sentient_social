use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :sentient_social, SentientSocialWeb.Endpoint,
  secret_key_base: "xz3kuYWJ3euU6VgQFdgqQECRYEVStlzHEGoqNjZWRXJLIFx7ZM92Cax93K4HeoAR"

# Configure your database
config :sentient_social, SentientSocial.Repo,
  username: "postgres",
  password: "postgres",
  database: "sentient_social_prod",
  pool_size: 15
