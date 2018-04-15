defmodule SentientSocial.Twitter.EngagementTest do
  use SentientSocial.DataCase, async: true
  import Mox

  alias SentientSocial.Accounts
  alias SentientSocial.Twitter.Engagement
  alias ExTwitter.Model.Tweet

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  setup :verify_on_exit!

  describe "find_tweets/1" do
    test "returns an empty list when no keywords found" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      assert Engagement.find_tweets(user) == []
    end

    test "finds tweets with text matching the user's keywords" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      Accounts.create_keyword(%{text: "keyword1"}, user)
      Accounts.create_keyword(%{text: "keyword2"}, user)

      expect(@twitter_client, :search, 2, fn query, [count: _count] ->
        [%Tweet{text: "Tweet #{query} text"}]
      end)

      tweets =
        user
        |> Engagement.find_tweets()
        |> Enum.map(fn tweet -> tweet.text end)

      assert Enum.member?(tweets, "Tweet keyword1 text")
      assert Enum.member?(tweets, "Tweet keyword2 text")
    end
  end

  describe "favorite_tweets/1" do
    test "finds and favorites tweets based on user keywords" do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      Accounts.create_keyword(%{text: "keyword1"}, user)
      Accounts.create_keyword(%{text: "keyword2"}, user)

      expect(@twitter_client, :search, 2, fn query, [count: _count] ->
        [%Tweet{text: "Tweet #{query} text"}]
      end)

      tweets =
        user
        |> Engagement.favorite_tweets()
        |> Enum.map(fn tweet -> tweet.text end)

      assert Enum.member?(tweets, "Tweet keyword1 text")
      assert Enum.member?(tweets, "Tweet keyword2 text")
    end
  end
end
