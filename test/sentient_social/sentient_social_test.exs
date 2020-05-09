defmodule SentientSocialTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Factory

  test "find_and_favorite_tweets" do
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

    favorite_fn = fn id -> Factory.build_external_tweet(id: id) end

    favorited_tweets =
      SentientSocial.find_and_favorite_tweets([], search_fn, term_provider_fn, favorite_fn)
      |> Enum.map(fn tweet -> tweet.id end)

    assert favorited_tweets == [1, 5]
  end

  test "find_and_favorite_tweets doesn't favorite previously favorited tweets" do
    term_provider_fn = fn ->
      ["cool tweets", "okay tweets"]
    end

    search_fn = fn
      "cool tweets" -> [Factory.build_external_tweet(id: 1)]
      "okay tweets" -> [Factory.build_external_tweet(id: 2)]
    end

    favorite_fn = fn id -> Factory.build_external_tweet(id: id) end

    previously_favorited_tweets = [Factory.build_tweet(id: 2)]

    favorited_tweets =
      SentientSocial.find_and_favorite_tweets(
        previously_favorited_tweets,
        search_fn,
        term_provider_fn,
        favorite_fn
      )
      |> Enum.map(& &1.id)

    assert favorited_tweets == [1]
  end

  test "favorite_tweet" do
    tweet = Factory.build_external_tweet(id: 1)
    favorite_fn = fn 1 -> tweet end

    favorited_tweet = SentientSocial.create_favorite(tweet, favorite_fn)
    assert favorited_tweet.id == tweet.id

    assert nil == SentientSocial.create_favorite(nil, favorite_fn)
  end
end
