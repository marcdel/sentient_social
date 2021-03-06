defmodule SentientSocial.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    OpenTelemetry.register_application_tracer(:sentient_social)

    children = [
      # Start the Ecto repository
      SentientSocial.Repo,
      # Start the Telemetry supervisor
      SentientSocialWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SentientSocial.PubSub},
      # Start the Endpoint (http/https)
      SentientSocialWeb.Endpoint,
      # Start a worker by calling: SentientSocial.Worker.start_link(arg)
      # {SentientSocial.Worker, arg}
      SentientSocial.Boundary.FavoriteManager
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SentientSocial.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SentientSocialWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
