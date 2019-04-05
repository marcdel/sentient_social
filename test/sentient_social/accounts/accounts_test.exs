defmodule SentientSocial.AccountsTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{Credential, User}
  alias SentientSocial.Repo

  describe "list_users/0" do
    test "returns all users" do
      Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})
      Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

      users = Accounts.list_users()
      assert Enum.count(users) == 2
    end
  end

  describe "get_user/1" do
    test "returns the user with the specified id or nil" do
      {:ok, user} = Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})

      found_user = Accounts.get_user(1)
      assert found_user == user

      assert Accounts.get_user(2) == nil
    end
  end

  describe "get_user!/1" do
    test "returns the user with the specified id or raise" do
      {:ok, user} = Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

      found_user = Accounts.get_user!(2)
      assert found_user == user

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(1)
      end
    end
  end

  describe "get_user_by/1" do
    test "returns the user with the specified key or nil" do
      {:ok, marc} = Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})
      {:ok, jackie} = Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

      user = Accounts.get_user_by(id: 1)
      assert user == marc

      user = Accounts.get_user_by(name: "Jackie")
      assert user == jackie

      user = Accounts.get_user_by(username: "marcdel")
      assert user == marc

      user = Accounts.get_user_by(id: 2, name: "Jackie", username: "jackie")
      assert user == jackie

      user = Accounts.get_user_by(id: 666)
      assert user == nil
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

  describe "credentials" do
    @valid_attrs %{email: "some email", password: "some password"}
    @update_attrs %{email: "some updated email", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential_fixture(%{email: "user@email.com"})
      assert [%{email: "user@email.com"} | _] = Accounts.list_credentials()
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture(%{email: "user@email.com"})
      assert %{email: "user@email.com"} = Accounts.get_credential!(credential.id)
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.email == "some email"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, @update_attrs)

      assert credential.email == "some updated email"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture(%{email: "user@email.com"})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert %{email: "user@email.com"} = Accounts.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end
end
