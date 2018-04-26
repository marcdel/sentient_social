defmodule SentientSocial.Twitter.EngagementTest do
  use SentientSocial.DataCase, async: true
  import Mox

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Twitter.Engagement

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  setup :verify_on_exit!

  describe "favorite_new_keyword_tweets/1" do
    test "returns an empty list when no keywords found" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png",
          access_token: "token",
          access_token_secret: "secret"
        })

      assert Engagement.favorite_new_keyword_tweets(user.username) == []
    end

    test "finds and favorites tweets based on user keywords" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png",
          access_token: "token",
          access_token_secret: "secret"
        })

      tweet1 = %Tweet{id: 1, text: "Tweet keyword1 text"}
      Accounts.create_keyword(%{text: "keyword1"}, user)
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet1] end)
      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:ok, tweet1} end)

      tweet2 = %Tweet{id: 2, text: "Tweet keyword2 text"}
      Accounts.create_keyword(%{text: "keyword2"}, user)
      expect(@twitter_client, :search, 1, fn "keyword2", [count: _count] -> [tweet2] end)
      expect(@twitter_client, :create_favorite, 1, fn 2 -> {:ok, tweet2} end)

      tweets = Engagement.favorite_new_keyword_tweets(user.username)

      assert Enum.count(tweets) == 2
      assert Enum.member?(tweets, tweet1)
      assert Enum.member?(tweets, tweet2)
    end

    test "does not return tweets that have already been favorited" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png",
          access_token: "token",
          access_token_secret: "secret"
        })

      tweet1 = %Tweet{id: 1, text: "Tweet keyword1 text"}
      Accounts.create_keyword(%{text: "keyword1"}, user)
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet1] end)

      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:error, ""} end)

      tweets = Engagement.favorite_new_keyword_tweets(user.username)

      assert tweets == []
    end
  end
end
