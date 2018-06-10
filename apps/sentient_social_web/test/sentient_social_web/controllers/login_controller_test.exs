defmodule SentientSocialWeb.LoginControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  import SentientSocial.Factory
  alias SentientSocial.Accounts

  describe "index" do
    test "renders the login page", %{conn: conn} do
      conn = get(conn, login_path(conn, :index))
      assert html_response(conn, 200) =~ "Log In"
    end
  end

  describe "create" do
    test "shows an error when email is not provided", %{conn: conn} do
      conn = post(conn, login_path(conn, :index, %{email: ""}))
      assert get_flash(conn, :error) == "Please enter your email address."
    end

    test "redirects to /auth/twitter when user has no access tokens", %{conn: conn} do
      insert(:user, %{email: "user@email.com", access_token: nil, access_token_secret: nil})
      conn = post(conn, login_path(conn, :index, %{email: "user@email.com"}))
      assert redirected_to(conn) == "/auth/twitter"
    end

    test "still redirects to /auth/twitter when user already has access tokens", %{conn: conn} do
      insert(:user, %{
        id: 1234,
        email: "user@email.com",
        access_token: "abcd",
        access_token_secret: "dcba"
      })

      conn = post(conn, login_path(conn, :index, %{email: "user@email.com"}))
      assert get_session(conn, :current_user) == 1234
      assert redirected_to(conn) == "/auth/twitter"
    end

    test "creates a user with the provided email when one doesn't exist", %{conn: conn} do
      post(conn, login_path(conn, :index, %{email: "user@email.com"}))
      assert Accounts.list_users() |> Enum.count() == 1
      assert [%{email: "user@email.com"}] = Accounts.list_users()
    end

    test "does not create a user when one already exists", %{conn: conn} do
      insert(:user, %{email: "user@email.com"})
      post(conn, login_path(conn, :index, %{email: "user@email.com"}))
      assert Accounts.list_users() |> Enum.count() == 1
    end
  end
end
