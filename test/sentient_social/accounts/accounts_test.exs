defmodule SentientSocial.AccountsTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
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

  describe "get_user_by_email/1" do
    setup do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      Accounts.add_token(user, %{
        provider: "twitter",
        token: "twitter token",
        token_secret: "twitter token_secret"
      })

      :ok
    end

    test "returns the user with the specified email or nil" do
      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.name == "Marc"
      assert user.username == "marcdel"
      assert user.credential.email == "marcdel@email.com"
    end

    test "returns the user's email and hashed password" do
      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.credential.email == "marcdel@email.com"
      assert user.credential.password == nil
      assert user.credential.password_hash != nil
    end

    test "returns the user's token" do
      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.token.provider == "twitter"
      assert user.token.token == "twitter token"
      assert user.token.token_secret == "twitter token_secret"
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
      assert "can't be blank" in errors_on(changeset).username

      {:error, changeset} = Accounts.create_user(%{username: "marcdel"})
      assert "can't be blank" in errors_on(changeset).name
    end

    test "username must be between 1 and 20 characters" do
      {:error, changeset} = Accounts.create_user(%{name: "Jackie", username: ""})
      assert "can't be blank" in errors_on(changeset).username

      {:error, changeset} =
        Accounts.create_user(%{name: "Marc", username: String.duplicate("a", 21)})

      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
    end
  end

  describe "register_user/1" do
    test "can create a user with a credential" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      assert %{
               name: "Marc",
               username: "marcdel",
               credential: %{
                 email: "marcdel@email.com"
               }
             } = user
    end

    test "cannot create a user without a credential" do
      assert {:error, changeset} =
               Accounts.register_user(%{
                 name: "Marc",
                 username: "marcdel"
               })

      assert "can't be blank" in errors_on(changeset).credential
    end
  end

  describe "authenticate_by_email_and_password/2" do
    @email "marcdel@localhost"
    @pass "123456"

    setup do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: @email,
            password: @pass
          }
        })

      {:ok, user: user}
    end

    test "returns user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_password(@email, @pass)
    end

    test "returns unauthorized error with invalid password" do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_password(@email, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_email_and_password("bademail@localhost", @pass)
    end
  end

  describe "add_token/2" do
    test "can add a token to a user" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      user = SentientSocial.Repo.preload(user, :token)

      {:ok, user} =
        Accounts.add_token(user, %{
          provider: "twitter",
          token: "some token",
          token_secret: "some token_secret"
        })

      assert %{
               provider: "twitter",
               token: "some token",
               token_secret: "some token_secret"
             } = user.token
    end

    test "cannot add a token if user is missing" do
      {:error, changeset} =
        Accounts.add_token(%User{}, %{
          provider: "twitter",
          token: "some token",
          token_secret: "some token_secret"
        })

      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).username
    end
  end
end
