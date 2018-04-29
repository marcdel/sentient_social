defmodule SentientSocial.Accounts.UserServer do
  @moduledoc """
  A user server process that holds a `User` struct as its state.
  """

  use GenServer

  require Logger

  alias SentientSocial.Accounts.{UserRegistry}
  alias SentientSocial.Twitter.Engagement

  @min_interval 1
  @max_interval 30

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

  @doc """
  Returns a random time in milliseconds between the min and max
  """
  @spec favorite_interval() :: integer
  def favorite_interval do
    @min_interval..@max_interval
    |> Enum.random()
    |> :timer.minutes()
  end

  defp schedule_favoriting_tweets(username) do
    next_interval = favorite_interval()

    Logger.info(
      "Scheduling next favorites for '#{username}' in #{next_interval / 60_000} minutes."
    )

    Process.send_after(self(), {:favorite_tweets, username}, next_interval)
  end

  @spec init(String.t()) :: {:ok, map}
  def init(username) do
    Logger.info("Spawned user server process for '#{username}'.")
    schedule_favoriting_tweets(username)

    {:ok, %{}}
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def handle_info({:favorite_tweets, username}, state) do
    Engagement.favorite_new_keyword_tweets(username)
    schedule_favoriting_tweets(username)

    {:noreply, state}
  end

  @spec terminate(atom, map :: term) :: term
  def terminate(_reason, _state) do
    :ok
  end
end
