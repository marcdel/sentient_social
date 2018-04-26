defmodule SentientSocial.Accounts.UserServer do
  @moduledoc """
  A user server process that holds a `User` struct as its state.
  """

  use GenServer

  require Logger

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{UserRegistry}
  alias SentientSocial.Twitter.Engagement

  @favorite_interval :timer.minutes(30)

  @doc """
  Spawns a new user server process registered under the given `username`.
  """
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(username) do
    GenServer.start_link(__MODULE__, username, name: via_tuple(username))
  end

  @doc """
  Finds and favorites new tweets and automatically re-runs after the specified amount of time
  """
  @spec favorite_some_tweets(String.t()) :: list(%Tweet{})
  def favorite_some_tweets(username) do
    username
    |> user_pid()
    |> send({:favorite_tweets, username})
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

  defp schedule_favoriting_tweets(username) do
    Logger.info(
      "Scheduling next favorites for '#{username}' in #{@favorite_interval / 60000} minutes."
    )

    Process.send_after(self(), {:favorite_tweets, username}, @favorite_interval)
  end

  @spec init(String.t()) :: {:ok, map}
  def init(username) do
    Logger.info("Spawned user server process named '#{username}'.")
    schedule_favoriting_tweets(username)

    {:ok, %{}}
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def handle_info({:favorite_tweets, username}, state) do
    Logger.info("Looking for tweets to favorite for '#{username}' now.")

    username
    |> Accounts.get_user_by_username()
    |> Engagement.favorite_new_keyword_tweets()

    schedule_favoriting_tweets(username)

    {:noreply, state}
  end

  @spec terminate(atom, map :: term) :: term
  def terminate(_reason, _state) do
    :ok
  end
end
