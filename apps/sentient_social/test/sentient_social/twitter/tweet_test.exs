defmodule SentientSocial.Twitter.TweetTest do
  use ExUnit.Case
  alias SentientSocial.Twitter.Tweet

  describe "new/1" do
    test "handles regular tweets" do
      ex_twitter_tweet = %ExTwitter.Model.Tweet{
        id: 1,
        text: "Tweet #keyword1 text",
        entities: %{
          hashtags: [
            %{text: "keyword1"}
          ]
        },
        user: %ExTwitter.Model.User{
          id: 2,
          screen_name: "user",
          description: "description"
        }
      }

      tweet = Tweet.new(ex_twitter_tweet)

      assert tweet.id == 1
      assert tweet.text == "Tweet #keyword1 text"
      assert tweet.user_id == 2
      assert tweet.screen_name == "user"
      assert tweet.description == "description"
      assert tweet.hashtags == ["keyword1"]
    end

    test "handles extended tweets" do
      ex_twitter_tweet = %ExTwitter.Model.Tweet{
        id: 1,
        full_text: "Tweet #keyword1 text",
        entities: %{
          hashtags: [
            %{text: "keyword1"}
          ]
        },
        user: %ExTwitter.Model.User{
          screen_name: "user",
          description: "description"
        }
      }

      tweet = Tweet.new(ex_twitter_tweet)

      assert tweet.id == 1
      assert tweet.text == "Tweet #keyword1 text"
      assert tweet.screen_name == "user"
      assert tweet.description == "description"
      assert tweet.hashtags == ["keyword1"]
    end
  end
end
