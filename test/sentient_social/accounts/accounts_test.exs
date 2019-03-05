defmodule SentientSocial.AccountsTest do
  use ExUnit.Case

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  describe "list_users/0" do
    test "returns two hardcoded users" do
      users = Accounts.list_users()
      assert Enum.count(users) == 2
    end
  end

  describe "get_user/1" do
    test "returns the user with the specified id" do
      user = Accounts.get_user("1")
      assert user == %User{id: "1", name: "Marc", username: "marcdel"}
    end
  end

  describe "get_user_by/1" do
    test "returns the user with the specified key" do
      user = Accounts.get_user_by(id: "1")
      assert user == %User{id: "1", name: "Marc", username: "marcdel"}

      user = Accounts.get_user_by(name: "Jackie")
      assert user == %User{id: "2", name: "Jackie", username: "jackie"}

      user = Accounts.get_user_by(username: "marcdel")
      assert user == %User{id: "1", name: "Marc", username: "marcdel"}

      user = Accounts.get_user_by(id: "2", name: "Jackie", username: "jackie")
      assert user == %User{id: "2", name: "Jackie", username: "jackie"}
    end
  end
end
