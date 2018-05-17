defmodule TweetFilterTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Twitter.TweetFilter

  describe "filter/1" do
    test "removes tweets with more than the specified hashtags" do
      user = insert(:user)

      valid_tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello #one #two #three #four",
          entities: %{
            hashtags: [
              %{text: "one"},
              %{text: "two"},
              %{text: "three"},
              %{text: "four"}
            ]
          }
        })

      valid_tweet_two =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello",
          entities: %{
            hashtags: []
          }
        })
        |> make_retweet()

      invalid_tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "#one #two #three #four #five #six hello",
          entities: %{
            hashtags: [
              %{text: "one"},
              %{text: "two"},
              %{text: "three"},
              %{text: "four"},
              %{text: "five"},
              %{text: "six"}
            ]
          }
        })
        |> make_retweet()

      invalid_tweet_two =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello #one #two hello #three #four #five #six",
          entities: %{
            hashtags: [
              %{text: "one"},
              %{text: "two"},
              %{text: "three"},
              %{text: "four"},
              %{text: "five"},
              %{text: "six"}
            ]
          }
        })

      tweets = [valid_tweet, invalid_tweet, valid_tweet_two]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(valid_tweet)

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(valid_tweet_two)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_tweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_tweet_two)
    end

    test "removes tweets with only hashtags" do
      user = insert(:user)

      valid_tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello #one #two #three #four",
          entities: %{
            hashtags: [
              %{text: "one"},
              %{text: "two"},
              %{text: "three"},
              %{text: "four"}
            ]
          }
        })
        |> make_retweet()

      valid_tweet_two =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello",
          entities: %{
            hashtags: []
          }
        })

      invalid_tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "#one #two #three #four",
          entities: %{
            hashtags: [
              %{text: "one"},
              %{text: "two"},
              %{text: "three"},
              %{text: "four"}
            ]
          }
        })
        |> make_retweet()

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
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello",
          entities: %{
            hashtags: []
          }
        })
        |> make_retweet()

      invalid_tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "hello #spam",
          entities: %{
            hashtags: [
              %{text: "spam"}
            ]
          }
        })
        |> make_retweet()

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

    test "handles regular and extended tweets" do
      user = insert(:user)

      regular_tweet = build(:ex_twitter_tweet)
      regular_retweet = build(:ex_twitter_tweet) |> make_retweet()
      extended_tweet = build(:ex_twitter_extended_tweet)
      extended_retweet = build(:ex_twitter_extended_tweet) |> make_retweet()

      invalid_regular_tweet = build(:ex_twitter_tweet) |> make_invalid()
      invalid_regular_retweet = build(:ex_twitter_tweet) |> make_retweet() |> make_invalid()
      invalid_extended_tweet = build(:ex_twitter_extended_tweet) |> make_invalid()

      invalid_extended_retweet =
        build(:ex_twitter_extended_tweet) |> make_retweet() |> make_invalid()

      tweets = [
        regular_tweet,
        regular_retweet,
        extended_tweet,
        extended_retweet,
        invalid_regular_tweet,
        invalid_regular_retweet,
        invalid_extended_tweet,
        invalid_extended_retweet
      ]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(regular_tweet)

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(regular_retweet)

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(extended_tweet)

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(extended_retweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_regular_tweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_regular_retweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_extended_tweet)

      refute tweets
             |> TweetFilter.filter(user)
             |> Enum.member?(invalid_extended_retweet)
    end
  end
end
