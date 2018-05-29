defmodule SentientSocial.Twitter.TweetFilter do
  @moduledoc """
  Filters out tweets the user doesn't want to interact with
  """

  require Logger

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter.Tweet

  @max_hashtags 5

  @spec filter(list(%Tweet{}), %User{}) :: list(%Tweet{})
  def filter(tweets, user) do
    Enum.reject(tweets, fn tweet ->
      is_own_tweet?(tweet, user) || too_many_hashtags?(tweet) || only_hashtags?(tweet) ||
        contains_muted_keyword?(tweet, user)
    end)
  end

  @spec is_own_tweet?(%Tweet{}, %User{}) :: boolean
  defp is_own_tweet?(tweet, user) do
    tweet.screen_name == user.username
  end

  @spec too_many_hashtags?(%Tweet{}) :: boolean
  defp too_many_hashtags?(tweet) do
    Enum.count(tweet.hashtags) > @max_hashtags
  end

  @spec only_hashtags?(%Tweet{}) :: boolean
  defp only_hashtags?(tweet) do
    word_count =
      tweet
      |> words_in_tweet()
      |> Enum.count()

    hashtag_count = Enum.count(tweet.hashtags)

    word_count == hashtag_count
  end

  @spec contains_muted_keyword?(%Tweet{}, %User{}) :: boolean
  defp contains_muted_keyword?(tweet, user) do
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

  @spec words_in_tweet(%Tweet{}) :: list(String.t())
  defp words_in_tweet(%Tweet{text: nil}), do: []
  defp words_in_tweet(%Tweet{text: text}), do: String.split(text, " ")
end
