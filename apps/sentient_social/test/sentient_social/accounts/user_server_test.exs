defmodule UserServerTest do
  use SentientSocial.DataCase

  alias SentientSocial.Accounts.UserServer

  @spec generate_user_name() :: String.t()
  defp generate_user_name do
    "user-#{:rand.uniform(1_000_000)}"
  end

  test "spawning a user server process" do
    username = generate_user_name()

    assert {:ok, _pid} = UserServer.start_link(username)
  end

  test "a user process is registered under a unique name" do
    username = generate_user_name()

    assert {:ok, _pid} = UserServer.start_link(username)

    assert {:error, _reason} = UserServer.start_link(username)
  end

  describe "user_pid" do
    test "returns a PID if it has been registered" do
      username = generate_user_name()

      {:ok, pid} = UserServer.start_link(username)

      assert ^pid = UserServer.user_pid(username)
    end

    test "returns nil if the user process does not exist" do
      refute UserServer.user_pid("nonexistent-user")
    end
  end
end
