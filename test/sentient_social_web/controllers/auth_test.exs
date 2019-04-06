defmodule SentientSocialWeb.AuthTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocialWeb.Auth
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(SentientSocialWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "call places user from session into assigns", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{id: 2, name: "Jackie", username: "jackie"})

    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Auth.init([]))

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, Auth.init([]))
    assert conn.assigns.current_user == nil
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{})
      |> Auth.authenticate_user([])

    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  describe("registered user") do
    setup do
      {:ok, user} =
        Accounts.register_user(%{
          id: 1,
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      {:ok, user: user}
    end

    test "login with a valid username and pass", %{conn: conn, user: user} do
      {:ok, conn} = Auth.login_by_email_and_password(conn, "marcdel@email.com", "password")

      assert conn.assigns.current_user.id == user.id
    end

    test "login with a not found user", %{conn: conn} do
      assert {:error, :not_found, _conn} =
               Auth.login_by_email_and_password(conn, "me@test", "secret")
    end

    test "login with password mismatch", %{conn: conn} do
      assert {:error, :unauthorized, _conn} =
               Auth.login_by_email_and_password(conn, "marcdel@email.com", "wrong password")
    end
  end
end
