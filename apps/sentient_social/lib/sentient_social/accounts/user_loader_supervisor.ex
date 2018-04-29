defmodule SentientSocial.Accounts.UserLoaderSupervisor do
  @moduledoc """
  Supervises the user supervisor and user loader and ensures a user server is
  started for each user when the app starts and if the user supervisor goes down.
  """

  use Supervisor

  alias SentientSocial.Accounts.{UserSupervisor, UserLoader}

  @doc """
  Spawns a new process to keep a user server running for each user
  """
  @spec start_link(Supervisor.options()) :: GenServer.on_start()
  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def init(:ok) do
    Supervisor.init(children(), strategy: :rest_for_one)
  end

  defp children do
    [
      UserSupervisor,
      worker(Task, [&UserLoader.load/0], restart: :temporary)
    ]
  end
end
