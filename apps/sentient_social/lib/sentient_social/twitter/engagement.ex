defmodule SentientSocial.Twitter.Engagement do
  @moduledoc """
  Finds tweets matching the specified user's keywords
  """

  require Logger

  alias ExTwitter.Config
  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter.TweetFilter

  @max_engagements 1

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  @doc """
  Find and favorite tweets for the given user
  """
  @spec favorite_new_keyword_tweets(String, module) :: {:ok, [%Tweet{}]}
  def favorite_new_keyword_tweets(username, tweet_filter \\ TweetFilter) do
    Logger.info("Looking for tweets to favorite for '#{username}' now.")

    favorited_tweets =
      username
      |> Accounts.get_user_by_username()
      |> set_access_tokens()
      |> find_tweets()
      |> tweet_filter.filter()
      |> favorite_tweets()

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

  @spec favorite_tweets([%Tweet{}]) :: [%Tweet{}]
  defp favorite_tweets(tweets) do
    tweets
    |> Enum.map(fn tweet ->
      case @twitter_client.create_favorite(tweet.id) do
        {:ok, tweet} -> tweet
        {:error, _message} -> nil
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
end
