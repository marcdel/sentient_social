defmodule UserLoaderTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Accounts.{UserLoader, UserServer}

  test "starts a user server for each user in the database" do
    user1 = insert(:user)
    user2 = insert(:user)
    user3 = insert(:user)

    assert :ok = UserLoader.load()

    assert UserServer.user_pid(user1.username) != nil
    assert UserServer.user_pid(user2.username) != nil
    assert UserServer.user_pid(user3.username) != nil
  end
end
