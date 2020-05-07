defmodule SentientSocial.Core.TweetFilterTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Core.TweetFilter
  alias SentientSocial.Factory

  describe "filter/1" do
    test "filters out retweets, truncated tweets, and already favorited tweets" do
      tweets = [
        Factory.build_tweet(id: 1),
        Factory.build_tweet(id: 2, retweet?: true),
        Factory.build_tweet(id: 3, favorited?: true),
        Factory.build_tweet(id: 4, truncated?: true)
      ]

      filtered_tweets = TweetFilter.filter(tweets)

      assert Enum.map(filtered_tweets, & &1.id) == [1]
    end

    test "filters out tweets with more than 5 hashtags" do
      tweets = [
        Factory.build_tweet(id: 1, hashtags: ["1", "2"]),
        Factory.build_tweet(id: 2, hashtags: ["1", "2", "3", "4", "5"]),
        Factory.build_tweet(id: 3, hashtags: ["1", "2", "3", "4"]),
        Factory.build_tweet(id: 4, hashtags: ["1", "2", "3", "4", "5", "6"]),
        Factory.build_tweet(id: 4, hashtags: ["1", "2", "3", "4", "5", "6", "7"])
      ]

      filtered_tweets = TweetFilter.filter(tweets)

      assert Enum.map(filtered_tweets, & &1.id) == [1, 2, 3]
    end
  end
end
