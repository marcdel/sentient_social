defmodule SentientSocial.Twitter.RateLimitedTwitterClientTest do
  use SentientSocial.DataCase, async: true

  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Twitter.RateLimitedTwitterClient

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  @rate_limiter Application.get_env(:sentient_social, :rate_limiter)
  setup :verify_on_exit!

  describe "search/3" do
    test "calls the twitter client and returns those tweets" do
      user = insert(:user)
      tweets = [build(:tweet)]
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      expect(@twitter_client, :search, 1, fn "keyword", _ -> tweets end)

      assert ^tweets = RateLimitedTwitterClient.search("keyword", user)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      user = insert(:user)
      expect(@twitter_client, :search, 1, fn "keyword", _ -> [] end)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      assert [] = RateLimitedTwitterClient.search("keyword", user)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:deny, 1} end)
      assert {:deny, 1} = RateLimitedTwitterClient.search("keyword", user)
    end
  end

  describe "user/2" do
    test "calls the twitter client and returns the specified user" do
      user = insert(:user)
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      expect(@twitter_client, :user, 1, fn _id -> {:ok, user} end)

      assert {:ok, _user} = RateLimitedTwitterClient.user(user)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      user = insert(:user)
      expect(@twitter_client, :user, 1, fn _id -> {:ok, user} end)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      assert {:ok, _user} = RateLimitedTwitterClient.user(user)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:deny, 1} end)
      assert {:deny, 1} = RateLimitedTwitterClient.user(user)
    end
  end

  describe "create_favorite/3" do
    test "calls the twitter client and returns the specified tweet" do
      user = insert(:user)
      tweet = build(:tweet)
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      expect(@twitter_client, :create_favorite, 1, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} = RateLimitedTwitterClient.create_favorite(tweet.id, user)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :create_favorite, 1, fn _id -> {:ok, tweet} end)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      assert {:ok, _user} = RateLimitedTwitterClient.create_favorite(tweet.id, user)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:deny, 1} end)
      assert {:deny, 1} = RateLimitedTwitterClient.create_favorite(tweet.id, user)
    end
  end

  describe "destroy_favorite/3" do
    test "calls the twitter client and returns the specified tweet" do
      user = insert(:user)
      tweet = build(:tweet)
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      expect(@twitter_client, :destroy_favorite, 1, fn _id -> {:ok, tweet} end)

      assert {:ok, _user} = RateLimitedTwitterClient.destroy_favorite(tweet.id, user)
    end

    test "does not call twitter_client when rate limited, and returns :deny with the limit" do
      user = insert(:user)
      tweet = build(:tweet)
      expect(@twitter_client, :destroy_favorite, 1, fn _id -> {:ok, tweet} end)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 1} end)
      assert {:ok, _user} = RateLimitedTwitterClient.destroy_favorite(tweet.id, user)

      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:deny, 1} end)
      assert {:deny, 1} = RateLimitedTwitterClient.destroy_favorite(tweet.id, user)
    end
  end
end
