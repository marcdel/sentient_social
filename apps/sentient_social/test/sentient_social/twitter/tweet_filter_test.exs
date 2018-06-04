defmodule TweetFilterTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Twitter.TweetFilter

  describe "filter/1" do
    test "removes tweets with more than the specified hashtags" do
      user = insert(:user)

      valid_tweet =
        build(:tweet, %{
          id: 1,
          text: "hello #one #two #three #four",
          hashtags: ["one", "two", "three", "four"]
        })

      invalid_tweet =
        build(:tweet, %{
          id: 1,
          text: "hello #one #two hello #three #four #five #six",
          hashtags: ["one", "two", "three", "four", "five", "six"]
        })

      tweets = [valid_tweet, invalid_tweet]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(valid_tweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_tweet)
    end

    test "removes tweets with only hashtags" do
      user = insert(:user)

      valid_tweet =
        build(:tweet, %{
          id: 1,
          text: "hello #one #two #three #four",
          hashtags: ["one", "two", "three", "four"]
        })

      valid_tweet_two =
        build(:tweet, %{
          id: 2,
          text: "hello",
          hashtags: []
        })

      invalid_tweet =
        build(:tweet, %{
          id: 3,
          text: "#one #two #three #four",
          hashtags: ["one", "two", "three", "four"]
        })

      tweets = [valid_tweet, invalid_tweet, valid_tweet_two]
      filtered_tweets = TweetFilter.filter(tweets, user)

      assert filtered_tweets
             |> Enum.member?(valid_tweet)

      assert filtered_tweets
             |> Enum.member?(valid_tweet_two)

      refute filtered_tweets
             |> Enum.member?(invalid_tweet)
    end

    test "removes tweets containing muted keywords" do
      user = insert(:user)
      insert(:muted_keyword, %{text: "#spam", user: user})

      valid_tweet =
        build(:tweet, %{
          id: 1,
          text: "hello",
          hashtags: []
        })

      invalid_tweet =
        build(:tweet, %{
          id: 1,
          text: "hello #spam",
          hashtags: ["spam"]
        })

      tweets = [
        valid_tweet,
        invalid_tweet
      ]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(valid_tweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_tweet)
    end

    test "removes the user's own tweets" do
      user = insert(:user)

      invalid_tweet = build(:tweet, %{screen_name: user.username})
      assert TweetFilter.filter([invalid_tweet], user) == []
    end
  end
end
