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
  end
end
