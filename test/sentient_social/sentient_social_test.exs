defmodule SentientSocialTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Factory

  test "find_tweets" do
    term_provider_fn = fn ->
      ["cool tweets", "okay tweets"]
    end

    search_fn = fn
      "cool tweets" ->
        [
          Factory.build_external_tweet(id: 1),
          Factory.build_external_tweet(
            id: 2,
            retweeted_status: Factory.build_external_tweet(id: 6)
          ),
          Factory.build_external_tweet(id: 3, favorited: true)
        ]

      "okay tweets" ->
        [
          Factory.build_external_tweet(id: 4, truncated: true),
          Factory.build_external_tweet(id: 5, full_text: "the tweet", text: nil)
        ]
    end

    tweets = SentientSocial.find_tweets(search_fn, term_provider_fn)

    assert Enum.map(tweets, fn tweet -> tweet.id end) == [1, 5]
  end
end
