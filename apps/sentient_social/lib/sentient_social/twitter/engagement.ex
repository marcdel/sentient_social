defmodule SentientSocial.Twitter.Engagement do
  @moduledoc """
  Finds tweets matching the specified user's keywords
  """

  require Logger

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.{Tweet, TweetFilter, AutomatedInteraction}

  @max_engagements 1

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  @doc """
  Find and favorite tweets for the given user
  """
  @spec favorite_new_keyword_tweets(String, module) :: {:ok, [%Tweet{}]}
  def favorite_new_keyword_tweets(username, tweet_filter \\ TweetFilter) do
    Logger.info("Looking for tweets to favorite for '#{username}' now.")

    user =
      username
      |> Accounts.get_user_by_username()

    favorited_tweets =
      user
      |> Twitter.set_access_tokens()
      |> find_tweets()
      |> tweet_filter.filter(user)
      |> favorite_tweets(user)

    Logger.info("Favorited #{Enum.count(favorited_tweets)} tweets for '#{username}'.")

    {:ok, favorited_tweets}
  end

  @doc """
  Find and unfavorite tweets for the given user
  """
  @spec undo_automated_interactions(String) :: {:ok, [%Tweet{}]}
  def undo_automated_interactions(username) do
    Logger.info("Looking for tweets to unfavorite for '#{username}' now.")

    user =
      username
      |> Accounts.get_user_by_username()

    unfavorited_tweets =
      user
      |> Twitter.set_access_tokens()
      |> Twitter.automated_interactions_to_be_undone()
      |> unfavorite_tweets(user)

    Logger.info("Unfavorited #{Enum.count(unfavorited_tweets)} tweets for '#{username}'.")

    {:ok, unfavorited_tweets}
  end

  @spec find_tweets(%User{}) :: [%Tweet{}]
  defp find_tweets(user) do
    user
    |> Accounts.list_keywords()
    |> Enum.flat_map(fn keyword ->
      @twitter_client.search(keyword.text, count: @max_engagements, tweet_mode: "extended")
    end)
  end

  @spec favorite_tweets([%Tweet{}], %User{}) :: [%Tweet{}]
  defp favorite_tweets(tweets, user) do
    tweets
    |> Enum.map(fn tweet ->
      case @twitter_client.create_favorite(tweet.id) do
        {:ok, tweet} ->
          {:ok, _} = save_automated_interaction(tweet, user)
          tweet

        {:error, _message} ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  @spec unfavorite_tweets([%AutomatedInteraction{}], %User{}) :: [%AutomatedInteraction{}]
  defp unfavorite_tweets(interactions, user) do
    interactions
    |> Enum.map(fn interaction ->
      case @twitter_client.destroy_favorite(interaction.tweet_id) do
        {:ok, tweet} ->
          Twitter.mark_interaction_undone(interaction, user)
          tweet

        {:error, %{code: 144}} ->
          Logger.info("Tweet #{interaction.tweet_id} already unfavorited")
          Twitter.mark_interaction_undone(interaction, user)
          nil

        {:error, error} ->
          Logger.info("Unable to unfavorite tweet #{interaction.tweet_id}: #{error.message}")
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  @spec save_automated_interaction(%Tweet{}, %User{}) :: {:ok, %AutomatedInteraction{}}
  defp save_automated_interaction(tweet, user) do
    Twitter.create_automated_interaction(
      %{
        tweet_id: tweet.id,
        tweet_user_screen_name: tweet.screen_name,
        tweet_text: tweet.text,
        tweet_url: "https://twitter.com/statuses/#{tweet.id}",
        tweet_user_description: tweet.description,
        interaction_type: "favorite",
        undo_at: generate_undo_at_date()
      },
      user
    )
  end

  @spec generate_undo_at_date() :: Date.t()
  defp generate_undo_at_date do
    Date.utc_today() |> Date.add(7)
  end
end
