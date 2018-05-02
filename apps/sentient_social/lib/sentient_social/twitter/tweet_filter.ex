defmodule SentientSocial.Twitter.TweetFilter do
  @moduledoc """
  Filters out tweets the user doesn't want to interact with
  """

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  @max_hashtags 5

  @spec filter(list(Tweet.t()), %User{}) :: list(Tweet.t())
  def filter(tweets, user) do
    Enum.reject(tweets, fn tweet ->
      count_hashtags(tweet) > @max_hashtags || all_hashtags(tweet) ||
        contains_muted_keyword(tweet, user)
    end)
  end

  @spec count_hashtags(Tweet.t()) :: integer
  defp count_hashtags(tweet) do
    tweet
    |> words_in_tweet()
    |> Enum.filter(fn word -> String.starts_with?(word, "#") end)
    |> Enum.count()
  end

  @spec all_hashtags(Tweet.t()) :: boolean
  defp all_hashtags(tweet) do
    words = words_in_tweet(tweet)

    hashtags =
      words
      |> Enum.filter(fn word -> String.starts_with?(word, "#") end)

    words == hashtags
  end

  @spec contains_muted_keyword(Tweet.t(), %User{}) :: boolean
  defp contains_muted_keyword(tweet, user) do
    muted_keywords =
      user
      |> Accounts.list_muted_keywords()
      |> Enum.map(fn keyword -> keyword.text end)

    tweet
    |> words_in_tweet()
    |> Enum.any?(fn word ->
      Enum.member?(muted_keywords, word)
    end)
  end

  @spec words_in_tweet(Tweet.t()) :: list(String.t())
  defp words_in_tweet(tweet) do
    tweet.text
    |> String.split(" ")
  end
end
