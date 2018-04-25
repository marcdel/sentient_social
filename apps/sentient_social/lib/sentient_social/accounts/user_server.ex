defmodule SentientSocial.Accounts.UserServer do
  @moduledoc """
  A user server process that holds a `User` struct as its state.
  """

  use GenServer

  require Logger

  alias SentientSocial.Accounts.{UserRegistry}

  @doc """
  Spawns a new user server process registered under the given `username`.
  """
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(username) do
    GenServer.start_link(__MODULE__, username, name: via_tuple(username))
  end

  @doc """
  Returns a tuple used to register and lookup a user server process by name.
  """
  @spec via_tuple(String.t()) :: {:via, Registry, {UserRegistry, String.t()}}
  def via_tuple(username) do
    {:via, Registry, {UserRegistry, username}}
  end

  @doc """
  Returns the `pid` of the user server process registered under the
  given `username`, or `nil` if no process is registered.
  """
  @spec user_pid(String.t()) :: pid | {atom, node} | nil
  def user_pid(username) do
    username
    |> via_tuple()
    |> GenServer.whereis()
  end

  @spec init(String.t()) :: {:ok, map}
  def init(username) do
    Logger.info("Spawned user server process named '#{username}'.")

    {:ok, %{}}
  end

  @spec terminate(atom, map :: term) :: term
  def terminate(_reason, _state) do
    :ok
  end

  # defp my_username do
  #   Registry.keys(UserRegistry, self()) |> List.first()
  # end
end
