defmodule SentientSocial.Twitter.TweetFilter do
  @moduledoc """
  Filters out tweets the user doesn't want to interact with
  """

  require Logger

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  @max_hashtags 5

  @spec filter(list(Tweet.t()), %User{}) :: list(Tweet.t())
  def filter(tweets, user) do
    Enum.reject(tweets, fn tweet ->
      too_many_hashtags?(tweet) || all_hashtags?(tweet) || contains_muted_keyword?(tweet, user)
    end)
  end

  @spec too_many_hashtags?(Tweet.t()) :: boolean
  defp too_many_hashtags?(tweet) do
    too_many_hashtags = count_hashtags(tweet) > @max_hashtags

    if too_many_hashtags do
      Logger.info(
        "The tweet '#{tweet.text}' was not fav'ed because it contained too many hashtags"
      )
    end

    too_many_hashtags
  end

  @spec all_hashtags?(Tweet.t()) :: boolean
  defp all_hashtags?(tweet) do
    all_hashtags = words_in_tweet(tweet) == hashtags_in_tweet(tweet)

    if all_hashtags do
      Logger.info("The tweet '#{tweet.text}' was not fav'ed because it contained only hashtags")
    end

    all_hashtags
  end

  @spec contains_muted_keyword?(Tweet.t(), %User{}) :: boolean
  defp contains_muted_keyword?(tweet, user) do
    muted_keywords =
      user
      |> Accounts.list_muted_keywords()
      |> Enum.map(fn keyword -> keyword.text end)

    contains_muted_keyword =
      tweet
      |> words_in_tweet()
      |> Enum.any?(fn word ->
        Enum.member?(muted_keywords, word)
      end)

    if contains_muted_keyword do
      Logger.info("The tweet '#{tweet.text}' was not fav'ed because it contained a muted keyword")
    end

    contains_muted_keyword
  end

  @spec words_in_tweet(Tweet.t()) :: list(String.t())
  defp words_in_tweet(tweet) do
    tweet.text
    |> String.split(" ")
  end

  @spec hashtags_in_tweet(Tweet.t()) :: list(String.t())
  defp hashtags_in_tweet(tweet) do
    tweet
    |> words_in_tweet()
    |> Enum.filter(fn word -> String.starts_with?(word, "#") end)
  end

  @spec count_hashtags(Tweet.t()) :: integer
  defp count_hashtags(tweet) do
    tweet
    |> hashtags_in_tweet()
    |> Enum.count()
  end
end
