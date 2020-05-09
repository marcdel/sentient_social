defmodule SentientSocial.Core.TweetFilter do
  def filter(tweets, previously_favorited_tweets \\ []) do
    tweets = MapSet.difference(MapSet.new(tweets), MapSet.new(previously_favorited_tweets))

    Enum.filter(tweets, &do_filter/1)
  end

  defp do_filter(tweet) do
    basics(tweet) &&
      max_hashtags(tweet)
  end

  # retweet? and truncated? cause some/all of the hashtags to be
  # removed from the tweet object, so we filter these out
  defp basics(tweet) do
    tweet.retweet? == false &&
      tweet.truncated? == false &&
      tweet.favorited? == false
  end

  defp max_hashtags(%{hashtags: hashtags}) do
    Enum.count(hashtags) <= 5
  end
end
