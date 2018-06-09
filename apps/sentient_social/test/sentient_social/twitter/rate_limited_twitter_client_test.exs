defmodule SentientSocial.Twitter.RateLimitedTwitterClientTest do
  use SentientSocial.DataCase, async: true

  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Twitter.RateLimitedTwitterClient

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  setup :verify_on_exit!

  describe "search/3" do
    test "calls the twitter client and returns those tweets" do
      rate_limit = 1
      user = insert(:user)
      tweets = [build(:tweet)]
      expect(@twitter_client, :search, rate_limit, fn "keyword", _ -> tweets end)

      assert ^tweets = RateLimitedTwitterClient.search("keyword", user)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      rate_limit = 1
      user = insert(:user)
      expect(@twitter_client, :search, rate_limit, fn "keyword", _ -> [] end)

      assert [] = RateLimitedTwitterClient.search("keyword", user, rate_limit: rate_limit)

      assert {:deny, ^rate_limit} =
               RateLimitedTwitterClient.search("keyword", user, rate_limit: rate_limit)
    end
  end

  describe "user/2" do
    test "calls the twitter client and returns the specified user" do
      rate_limit = 1
      user = insert(:user)
      expect(@twitter_client, :user, rate_limit, fn _id -> {:ok, user} end)

      assert {:ok, _user} = RateLimitedTwitterClient.user(user, rate_limit: rate_limit)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      rate_limit = 1
      user = insert(:user)
      expect(@twitter_client, :user, rate_limit, fn _id -> {:ok, user} end)

      assert {:ok, _user} = RateLimitedTwitterClient.user(user, rate_limit: rate_limit)

      assert {:deny, ^rate_limit} = RateLimitedTwitterClient.user(user, rate_limit: rate_limit)
    end
  end

  describe "create_favorite/3" do
    test "calls the twitter client and returns the specified tweet" do
      rate_limit = 1
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :create_favorite, rate_limit, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} =
               RateLimitedTwitterClient.create_favorite(tweet.id, user, rate_limit: rate_limit)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      rate_limit = 1
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :create_favorite, rate_limit, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} =
               RateLimitedTwitterClient.create_favorite(tweet.id, user, rate_limit: rate_limit)

      assert {:deny, ^rate_limit} =
               RateLimitedTwitterClient.create_favorite(tweet.id, user, rate_limit: rate_limit)
    end
  end

  describe "destroy_favorite/3" do
    test "calls the twitter client and returns the specified tweet" do
      rate_limit = 1
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :destroy_favorite, rate_limit, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} =
               RateLimitedTwitterClient.destroy_favorite(tweet.id, user, rate_limit: rate_limit)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      rate_limit = 1
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :destroy_favorite, rate_limit, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} =
               RateLimitedTwitterClient.destroy_favorite(tweet.id, user, rate_limit: rate_limit)

      assert {:deny, ^rate_limit} =
               RateLimitedTwitterClient.destroy_favorite(tweet.id, user, rate_limit: rate_limit)
    end
  end
end
