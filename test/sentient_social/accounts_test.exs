defmodule SentientSocial.AccountsTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Repo

  describe "list_users/0" do
    test "returns all users" do
      Repo.insert(%User{id: 1})
      Repo.insert(%User{id: 2})

      users = Accounts.list_users()
      assert Enum.count(users) == 2
    end
  end

  describe "get_user/1" do
    test "returns the user with the specified id or nil" do
      Repo.insert(%User{id: 1})

      found_user = Accounts.get_user(1)
      assert %{id: 1} = found_user

      assert Accounts.get_user(2) == nil
    end
  end

  describe "get_user_by_email/1" do
    setup do
      user =
        Fixtures.registered_user(%{
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      {:ok, user: user}
    end

    test "returns the user with the specified email or nil" do
      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.credential.email == "marcdel@email.com"
    end

    test "returns the user's email and hashed password" do
      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.credential.email == "marcdel@email.com"
      assert user.credential.password == nil
      assert user.credential.password_hash != nil
    end

    test "returns the user's token", %{user: user} do
      {:ok, _} =
        Accounts.add_token(user, %{
          username: "user1",
          provider: "twitter",
          token: "twitter token",
          token_secret: "twitter token_secret"
        })

      user = Accounts.get_user_by_email("marcdel@email.com")

      assert user.token.provider == "twitter"
      assert user.token.token == "twitter token"
      assert user.token.token_secret == "twitter token_secret"
    end
  end

  describe "change_user/1" do
    test "returns a changeset for the user" do
      user = %User{credential: %{email: "user@email.com"}}
      %Ecto.Changeset{data: data} = Accounts.change_user(user)
      assert data == user
    end
  end

  describe "register_user/1" do
    test "can create a user with a credential" do
      {:ok, user} =
        Accounts.register_user(%{
          credential: %{
            email: "marcdel@email.com",
            password: "password",
            password_confirmation: "password"
          }
        })

      assert %{credential: %{email: "marcdel@email.com"}} = user
    end

    test "cannot create a user without matching passwords" do
      assert {:error, changeset} =
               Accounts.register_user(%{
                 credential: %{
                   email: "user@email.com",
                   password: "correct",
                   password_confirmation: "incorrect"
                 }
               })

      assert "passwords do not match" in errors_on(changeset).credential.password_confirmation
    end

    test "cannot create a user without a valid credential" do
      assert {:error, changeset} = Accounts.register_user(%{})
      assert "can't be blank" in errors_on(changeset).credential

      assert {:error, changeset} = Accounts.register_user(%{credential: %{}})
      assert "can't be blank" in errors_on(changeset).credential.email
      assert "can't be blank" in errors_on(changeset).credential.password
    end
  end

  describe "authenticate_by_email_and_password/2" do
    @email "marcdel@localhost"
    @pass "123456"

    setup do
      {:ok, user} =
        Accounts.register_user(%{
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
      user = Fixtures.registered_user()

      {:ok, user} =
        Accounts.add_token(user, %{
          username: "user1",
          provider: "twitter",
          token: "some token",
          token_secret: "some token_secret"
        })

      assert %{
               username: "user1",
               provider: "twitter",
               token: "some token",
               token_secret: "some token_secret"
             } = user.token
    end

    test "cannot add a token if user_id, username, provider, or tokens are missing" do
      {:error, changeset} = Accounts.add_token(%User{})

      assert "can't be blank" in errors_on(changeset).user_id
      assert "can't be blank" in errors_on(changeset).username
      assert "can't be blank" in errors_on(changeset).provider
      assert "can't be blank" in errors_on(changeset).token
      assert "can't be blank" in errors_on(changeset).token_secret
    end
  end

  describe "add_search_term/2" do
    test "can add a search_term to a user" do
      user = Fixtures.registered_user()

      {:ok, user} = Accounts.add_search_term(user, %{text: "some search_term"})
      {:ok, user} = Accounts.add_search_term(user, %{text: "other search_term"})

      assert [%{text: "some search_term"}, %{text: "other search_term"}] =
               Accounts.list_search_terms(user)
    end

    test "cannot add a search_term with invalid parameters" do
      user = Fixtures.registered_user()

      {:error, changeset} = Accounts.add_search_term(user, %{text: nil})

      assert "can't be blank" in errors_on(changeset).text
    end

    test "search_term text must be unique" do
      user = Fixtures.registered_user()

      {:ok, user} = Accounts.add_search_term(user, %{text: "search_term"})
      {:error, changeset} = Accounts.add_search_term(user, %{text: "search_term"})

      assert "already exists" in errors_on(changeset).text
    end

    test "cannot add a search_term if user is missing" do
      {:error, changeset} = Accounts.add_search_term(%User{}, %{text: "some search_term"})

      assert "can't be blank" in errors_on(changeset).user_id
    end
  end
end
