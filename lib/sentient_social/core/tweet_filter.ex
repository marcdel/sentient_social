defmodule SentientSocial.Core.TweetFilter do
  use OpenTelemetryDecorator

  @decorate trace("tweet_filter.filter")
  def filter(tweets, previously_favorited_tweets \\ []) do
    unfavorited_tweets =
      MapSet.difference(MapSet.new(tweets), MapSet.new(previously_favorited_tweets))

    filtered_tweets = Enum.filter(unfavorited_tweets, &do_filter/1)

    O11y.set_attributes(
      tweets: Enum.count(tweets),
      unfavorited_tweets: Enum.count(unfavorited_tweets),
      filtered_tweets: Enum.count(filtered_tweets)
    )

    filtered_tweets
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
