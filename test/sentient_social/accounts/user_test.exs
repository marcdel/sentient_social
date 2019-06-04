defmodule SentientSocial.Accounts.UserTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Accounts.User

  describe "username/1" do
    test "returns username from the token" do
      user = %{token: %{username: "user2"}}
      assert User.username(user) == "user2"
    end

    test "returns email if user doesn't have a token" do
      user = %{token: nil, credential: %{email: "user1@email.com"}}
      assert User.username(user) == "user1@email.com"
    end
  end
end
