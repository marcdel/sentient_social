defmodule SentientSocial.TwitterTest do
  use SentientSocial.DataCase
  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Twitter
  alias SentientSocial.Accounts
  alias ExTwitter.Model.User

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  @rate_limiter Application.get_env(:sentient_social, :rate_limiter)
  setup :verify_on_exit!

  describe "update_twitter_followers/1" do
    test "retreives the specified user's follower count and updates the users table" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      twitter_user = %User{screen_name: "testuser", followers_count: 150}
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 10} end)
      expect(@twitter_client, :user, 1, fn _id -> {:ok, twitter_user} end)

      {:ok, user} = Twitter.update_twitter_followers(user.username)

      assert user.twitter_followers_count == 150
    end

    test "does not modify the specified user when rate limited" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:deny, 1} end)

      {:ok, user} = Twitter.update_twitter_followers(user.username)

      assert user.twitter_followers_count == 0
    end

    test "does not modify the specified user when client returns an ExTwitter error" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 10} end)
      expect(@twitter_client, :user, 1, fn _id -> {:error, %ExTwitter.Error{}} end)

      {:ok, user} = Twitter.update_twitter_followers(user.username)

      assert user.twitter_followers_count == 0
    end

    test "does not modify the specified user when client returns another kind of error" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 10} end)
      expect(@twitter_client, :user, 1, fn _id -> {:error, %{}} end)

      {:error, _} = Twitter.update_twitter_followers(user.username)

      assert Accounts.get_user!(user.id).twitter_followers_count == 0
    end

    test "inserts a historical record of the specified user's follower count" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      twitter_user = %User{screen_name: "testuser", followers_count: 110}
      expect(@rate_limiter, :check, 1, fn _key, _time, _rate -> {:allow, 10} end)
      expect(@twitter_client, :user, 1, fn _id -> {:ok, twitter_user} end)

      {:ok, user} = Twitter.update_twitter_followers(user.username)

      historical_follower_counts = Twitter.list_historical_follower_counts(user)
      assert [count] = historical_follower_counts
      assert count.count == 110
    end
  end
end
