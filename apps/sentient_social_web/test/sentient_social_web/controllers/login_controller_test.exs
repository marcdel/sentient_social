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

    test "redirects to the twitter authentication route", %{conn: conn} do
      conn = post(conn, login_path(conn, :index, %{email: "user@email.com"}))
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
