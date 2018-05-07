defmodule UserServerTest do
  use SentientSocial.DataCase

  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Accounts.UserServer

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  setup :verify_on_exit!

  test "spawning a user server process" do
    user = build(:user)
    assert {:ok, _pid} = UserServer.start_link(user.username)
  end

  test "a user process is registered under a unique name" do
    user = build(:user)

    assert {:ok, _pid} = UserServer.start_link(user.username)
    assert {:error, _reason} = UserServer.start_link(user.username)
  end

  describe "user_pid" do
    test "returns a PID if it has been registered" do
      user = build(:user)

      {:ok, pid} = UserServer.start_link(user.username)

      assert ^pid = UserServer.user_pid(user.username)
    end

    test "returns nil if the user process does not exist" do
      refute UserServer.user_pid("nonexistent-user")
    end
  end

  describe "favorite_interval" do
    test "returns a number between @min_interval and @max_interval in milliseconds" do
      next_interval = UserServer.favorite_interval() / 60_000
      assert next_interval >= 1
      assert next_interval <= 30
    end
  end

  describe "handle_info({:favorite_tweets, username}, state)" do
    test "searches for and favorites tweets" do
      user = insert(:user)
      insert(:keyword, %{text: "keyword1", user: user})

      {:ok, pid} = UserServer.start_link(user.username)

      tweet = build(:ex_twitter_tweet, %{text: "Tweet #keyword1 text"})

      expect(@twitter_client, :search, 1, fn _, _ ->
        [tweet]
      end)

      expect(@twitter_client, :create_favorite, 1, fn _id -> {:ok, tweet} end)
      allow(@twitter_client, self(), pid)

      UserServer.handle_info({:favorite_tweets, user.username}, %{})
    end
  end

  describe "handle_info({:undo_interactions, username}, state)" do
    test "undoes automated_interactions with undo_at with the current date" do
      user = insert(:user)
      insert(:automated_interaction, %{undo_at: Date.utc_today(), user: user})

      {:ok, pid} = UserServer.start_link(user.username)

      tweet = build(:ex_twitter_tweet, %{text: "Tweet #keyword1 text"})

      expect(@twitter_client, :destroy_favorite, 1, fn _id -> {:ok, tweet} end)
      allow(@twitter_client, self(), pid)

      UserServer.handle_info({:undo_interactions, user.username}, %{})
    end
  end
end
