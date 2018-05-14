defmodule SentientSocial.TwitterTest do
  use SentientSocial.DataCase
  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Twitter

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  setup :verify_on_exit!

  describe "update_twitter_followers/1" do
    test "retreives the specified user's follower count and updates th users table" do
      user = insert(:user, %{username: "testuser", twitter_followers_count: 0})
      twitter_user = build(:ex_twitter_user, %{screen_name: "testuser", followers_count: 100})
      expect(@twitter_client, :user, 1, fn _id -> {:ok, twitter_user} end)

      {:ok, user} = Twitter.update_twitter_followers(user.username)

      assert user.twitter_followers_count == 100
    end
  end
end
