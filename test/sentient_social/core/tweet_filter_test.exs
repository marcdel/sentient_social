defmodule SentientSocial.Core.TweetFilterTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Core.TweetFilter
  alias SentientSocial.Factory

  test "filter/1" do
    tweets = [
      Factory.build_tweet(id: 1),
      Factory.build_tweet(id: 2, retweet?: true),
      Factory.build_tweet(id: 3, favorited?: true),
      Factory.build_tweet(id: 4, truncated?: true)
    ]

    filtered_tweets = TweetFilter.filter(tweets)

    assert Enum.map(filtered_tweets, & &1.id) == [1]
  end
end
