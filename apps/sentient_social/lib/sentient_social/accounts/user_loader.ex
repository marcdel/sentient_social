defmodule SentientSocial.Accounts.UserLoader do
  @moduledoc """
  Starts a user server process for each User in the database
  """

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.UserSupervisor

  @doc false
  @spec load() :: :ok
  def load do
    Accounts.list_users()
    |> Enum.each(fn user ->
      UserSupervisor.start_user(user.username)
    end)

    :ok
  end
end
