defmodule SentientSocial.Core.TweetFilter do
  def filter(tweets) do
    Enum.filter(tweets, &do_filter/1)
  end

  defp do_filter(tweet) do
    tweet.retweet? == false &&
      tweet.truncated? == false &&
      tweet.favorited? == false
  end
end
