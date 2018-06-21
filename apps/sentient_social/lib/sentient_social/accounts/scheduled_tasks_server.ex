defmodule SentientSocial.Accounts.ScheduledTasksServer do
  @moduledoc """
  Handles scheduling tasks and automated interactions for a user
  """

  use GenServer

  require Logger

  alias SentientSocial.Accounts.{UserRegistry}
  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.Engagement

  @min_interval 1
  @max_interval 30

  @doc """
  Spawns a new process registered under the given `username`.
  """
  @spec start_link(String.t(), []) :: GenServer.on_start()
  def start_link(username, options \\ []) do
    defaults = [
      favorite_tweets_function: &Engagement.favorite_new_keyword_tweets/1,
      undo_interactions: &Engagement.undo_automated_interactions/1,
      update_followers: &Twitter.update_twitter_followers/1
    ]

    options =
      defaults
      |> Keyword.merge(options)
      |> Enum.into(%{username: username})

    GenServer.start_link(__MODULE__, options, name: via_tuple(username))
  end

  @spec init(map) :: {:ok, map}
  def init(options) do
    Logger.info("Spawned user server process for '#{options.username}'.")

    schedule_favoriting_tweets(options.username)
    schedule_undoing_interactions(options.username)
    schedule_updating_twitter_follower_count(options.username)

    {:ok,
     %{
       username: options.username,
       favorite_tweets_function: options.favorite_tweets_function,
       undo_interactions: options.undo_interactions,
       update_followers: options.update_followers
     }}
  end

  @doc """
  Returns a tuple used to register and lookup a user server process by name.
  """
  @spec via_tuple(String.t()) :: {:via, Registry, {UserRegistry, String.t()}}
  def via_tuple(username) do
    {:via, Registry, {UserRegistry, "#{username}_scheduled_tasks_server"}}
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

    Process.send_after(self(), {:favorite_tweets}, next_interval)
  end

  defp schedule_undoing_interactions(username) do
    Logger.info("Scheduling undoing interactions for '#{username}' in 1 hour.")
    Process.send_after(self(), {:undo_interactions}, :timer.hours(1))
  end

  defp schedule_updating_twitter_follower_count(username) do
    Logger.info("Scheduling updating twitter followers count for '#{username}' in 1 hour.")
    Process.send_after(self(), {:update_twitter_followers}, :timer.hours(1))
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def handle_info({:favorite_tweets}, state) do
    state.favorite_tweets_function.(state.username)
    schedule_favoriting_tweets(state.username)

    {:noreply, state}
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def handle_info({:undo_interactions}, state) do
    state.undo_interactions.(state.username)
    schedule_undoing_interactions(state.username)

    {:noreply, state}
  end

  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def handle_info({:update_twitter_followers}, state) do
    state.update_followers.(state.username)
    schedule_updating_twitter_follower_count(state.username)

    {:noreply, state}
  end

  @spec terminate(atom, map :: term) :: term
  def terminate(_reason, _state) do
    :ok
  end
end
