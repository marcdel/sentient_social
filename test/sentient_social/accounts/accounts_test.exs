defmodule SentientSocial.AccountsTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Repo

  setup do
    Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})
    Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

    :ok
  end

  describe "list_users/0" do
    test "returns two hardcoded users" do
      users = Accounts.list_users()
      assert Enum.count(users) == 2
    end
  end

  describe "get_user/1" do
    test "returns the user with the specified id" do
      user = Accounts.get_user(1)
      assert %User{id: 1, name: "Marc", username: "marcdel"} = user
    end
  end

  describe "get_user_by/1" do
    test "returns the user with the specified key" do
      user = Accounts.get_user_by(id: 1)
      assert %User{id: 1, name: "Marc", username: "marcdel"} = user

      user = Accounts.get_user_by(name: "Jackie")
      assert %User{id: 2, name: "Jackie", username: "jackie"} = user

      user = Accounts.get_user_by(username: "marcdel")
      assert %User{id: 1, name: "Marc", username: "marcdel"} = user

      user = Accounts.get_user_by(id: 2, name: "Jackie", username: "jackie")
      assert %User{id: 2, name: "Jackie", username: "jackie"} = user
    end
  end

  describe "change_user/1" do
    test "returns a changeset for the user" do
      user = %User{name: "Jackie", username: "jackie"}
      %Ecto.Changeset{data: data} = Accounts.change_user(user)
      assert data == user
    end
  end

  describe "create_user/1" do
    test "name and username are required" do
      {:error, changeset} = Accounts.create_user(%{name: "Marc"})
      assert [username: {"can't be blank", [validation: :required]}] == changeset.errors

      {:error, changeset} = Accounts.create_user(%{username: "marcdel"})
      assert [name: {"can't be blank", [validation: :required]}] == changeset.errors
    end

    test "username must be between 1 and 20 characters" do
      {:error, changeset} = Accounts.create_user(%{name: "Jackie", username: ""})
      assert [username: {"can't be blank", [validation: :required]}] == changeset.errors

      {:error, changeset} =
        Accounts.create_user(%{name: "Marc", username: String.duplicate("a", 21)})

      assert [
               username:
                 {"should be at most %{count} character(s)",
                  [count: 20, validation: :length, kind: :max]}
             ] == changeset.errors
    end
  end
end
