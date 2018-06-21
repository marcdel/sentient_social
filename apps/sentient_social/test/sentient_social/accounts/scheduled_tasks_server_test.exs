defmodule ScheduledTasksServerTest do
  use SentientSocial.DataCase

  import SentientSocial.Factory

  alias SentientSocial.Accounts.ScheduledTasksServer

  test "spawning a user server process" do
    user = build(:user)
    assert {:ok, _pid} = ScheduledTasksServer.start_link(user.username)
  end

  test "a user process is registered under a unique name" do
    user = build(:user)
    assert {:ok, pid} = ScheduledTasksServer.start_link(user.username)
    assert {:error, {:already_started, pid}} = ScheduledTasksServer.start_link(user.username)
  end

  describe "user_pid" do
    test "returns a PID if it has been registered" do
      user = build(:user)
      {:ok, pid} = ScheduledTasksServer.start_link(user.username)
      assert ^pid = ScheduledTasksServer.user_pid(user.username)
    end

    test "returns nil if the user process does not exist" do
      refute ScheduledTasksServer.user_pid("nonexistent-user")
    end
  end

  describe "favorite_interval" do
    test "returns a number between @min_interval and @max_interval in milliseconds" do
      next_interval = ScheduledTasksServer.favorite_interval() / 60_000
      assert next_interval >= 1
      assert next_interval <= 30
    end
  end

  describe "handle_info({:favorite_tweets, args}, state)" do
    test "searches for and favorites tweets" do
      user = insert(:user)
      insert(:keyword, %{text: "keyword1", user: user})

      ScheduledTasksServer.start_link(user.username)

      favorite_tweets_function = fn _username -> send(self(), :favorite_tweets_called) end

      ScheduledTasksServer.handle_info({:favorite_tweets}, %{
        username: user.username,
        favorite_tweets_function: favorite_tweets_function
      })

      assert_received :favorite_tweets_called
    end
  end

  describe "handle_info({:undo_interactions, args}, state)" do
    test "undoes automated_interactions" do
      user = insert(:user)

      ScheduledTasksServer.start_link(user.username)

      undo_interactions = fn _username -> send(self(), :undo_interactions_called) end

      ScheduledTasksServer.handle_info({:undo_interactions}, %{
        username: user.username,
        undo_interactions: undo_interactions
      })

      assert_received :undo_interactions_called
    end
  end

  describe "handle_info({:update_followers, args}, state)" do
    test "updates the user's twitter followers" do
      user = insert(:user)

      ScheduledTasksServer.start_link(user.username)

      update_followers = fn _username -> send(self(), :update_followers_called) end

      ScheduledTasksServer.handle_info({:update_twitter_followers}, %{
        username: user.username,
        update_followers: update_followers
      })

      assert_received :update_followers_called
    end
  end
end
