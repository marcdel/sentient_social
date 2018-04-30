defmodule SentientSocial.Twitter.TweetFilter do
  @moduledoc """
  Filters out tweets the user doesn't want to interact with
  """

  alias ExTwitter.Model.Tweet

  @max_hashtags 5

  @spec filter(list(Tweet.t())) :: list(Tweet.t())
  def filter(tweets) do
    Enum.reject(tweets, fn tweet ->
      count_hashtags(tweet) > @max_hashtags || all_hashtags(tweet)
    end)
  end

  @spec count_hashtags(Tweet.t()) :: integer
  defp count_hashtags(tweet) do
    tweet.text
    |> String.split(" ")
    |> Enum.filter(fn word -> String.starts_with?(word, "#") end)
    |> Enum.count()
  end

  @spec all_hashtags(Tweet.t()) :: boolean
  defp all_hashtags(tweet) do
    words =
      tweet.text
      |> String.split(" ")

    hashtags =
      words
      |> Enum.filter(fn word -> String.starts_with?(word, "#") end)

    words == hashtags
  end
end
