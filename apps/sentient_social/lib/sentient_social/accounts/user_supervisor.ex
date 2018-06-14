defmodule SentientSocial.Accounts.UserSupervisor do
  @moduledoc """
  A supervisor that starts `UserServer` processes dynamically.
  """

  use DynamicSupervisor

  alias SentientSocial.Accounts.UserServer

  @spec start_link(DynamicSupervisor.options()) :: Supervisor.on_start()
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `UserServer` process and supervises it.
  """
  @spec start_user(String.t()) :: Supervisor.on_start()
  def start_user(username) do
    child_spec = %{
      id: UserServer,
      start: {UserServer, :start_link, [username]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `UserServer` process normally. It won't be restarted.
  """
  @spec stop_user(String.t()) :: term
  def stop_user(username) do
    child_pid = UserServer.user_pid(username)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
