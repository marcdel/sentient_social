defmodule SentientSocial.Twitter.Engagement do
  @moduledoc """
  Finds tweets matching the specified user's keywords
  """

  require Logger

  alias ExTwitter.Config
  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.{TweetFilter, AutomatedInteraction}

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
      |> set_access_tokens()
      |> find_tweets()
      |> tweet_filter.filter(user)
      |> favorite_tweets(user)

    Logger.info("Favorited #{Enum.count(favorited_tweets)} tweets for '#{username}'.")

    {:ok, favorited_tweets}
  end

  @spec find_tweets(%User{}) :: [%Tweet{}]
  defp find_tweets(user) do
    user
    |> Accounts.list_keywords()
    |> Enum.flat_map(fn keyword ->
      @twitter_client.search(keyword.text, count: @max_engagements)
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

  # Configure ExTwitter for the current process with the user's access tokens.
  # This allows the app to take actions on behalf of the user.
  @spec set_access_tokens(%User{}) :: %User{}
  defp set_access_tokens(user) do
    ExTwitter.configure(
      :process,
      Enum.concat(
        Config.get_tuples(),
        access_token: user.access_token,
        access_token_secret: user.access_token_secret
      )
    )

    user
  end

  @spec save_automated_interaction(%Tweet{}, %User{}) :: {:ok, %AutomatedInteraction{}}
  defp save_automated_interaction(%Tweet{retweeted_status: %{} = retweeted_status} = tweet, user) do
    Twitter.create_automated_interaction(
      %{
        tweet_id: tweet.id,
        tweet_user_screen_name: retweeted_status.user.screen_name,
        tweet_text: retweeted_status.text,
        tweet_url: "https://twitter.com/statuses/#{tweet.id}",
        tweet_user_description: retweeted_status.user.description,
        interaction_type: "favorite"
      },
      user
    )
  end

  defp save_automated_interaction(tweet, user) do
    Twitter.create_automated_interaction(
      %{
        tweet_id: tweet.id,
        tweet_user_screen_name: tweet.user.screen_name,
        tweet_text: tweet.text,
        tweet_url: "https://twitter.com/statuses/#{tweet.id}",
        tweet_user_description: tweet.user.description,
        interaction_type: "favorite"
      },
      user
    )
  end
end
