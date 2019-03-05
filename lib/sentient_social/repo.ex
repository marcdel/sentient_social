defmodule SentientSocial.Repo do
  use Ecto.Repo,
    otp_app: :sentient_social,
    adapter: Ecto.Adapters.Postgres
end
