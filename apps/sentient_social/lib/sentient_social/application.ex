defmodule SentientSocial.Application do
  @moduledoc """
  The SentientSocial Application Service.

  The sentient_social system business domain lives in this application.

  Exposes API to clients such as the `SentientSocialWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :ok = :error_logger.add_report_handler(Sentry.Logger)

    Supervisor.start_link(
      [
        supervisor(SentientSocial.Repo, []),
        {Registry, keys: :unique, name: SentientSocial.Accounts.UserRegistry},
        SentientSocial.Accounts.UserLoaderSupervisor,
        SentientSocial.Vault
      ],
      strategy: :one_for_one,
      name: SentientSocial.Supervisor
    )
  end
end
