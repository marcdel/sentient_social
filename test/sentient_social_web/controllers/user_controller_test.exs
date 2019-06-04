defmodule SentientSocialWeb.UserControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  alias SentientSocial.Accounts

  setup %{conn: conn} do
    user1 =
      Fixtures.registered_authorized_user(%{
        username: "user1",
        credential: %{
          email: "user1@email.com",
          password: "password"
        }
      })

    user2 =
      Fixtures.registered_authorized_user(%{
        username: "user2",
        credential: %{
          email: "user2@email.com",
          password: "password"
        }
      })

    {:ok, %{conn: conn, user1: user1, user2: user2}}
  end

  describe "when user is logged in" do
    test "GET /users/:id", %{conn: conn, user1: user1, user2: user2} do
      conn1 = sign_in(conn, user1)
      conn1 = get(conn1, Routes.user_path(conn1, :show, user1.id))
      assert html_response(conn1, 200) =~ user1.token.username

      conn2 = sign_in(conn, user2)
      conn2 = get(conn2, Routes.user_path(conn2, :show, user2.id))
      assert html_response(conn2, 200) =~ user2.token.username
    end

    test "shows user's saved search terms", %{conn: conn, user1: user1} do
      conn = sign_in(conn, user1)

      {:ok, user1} = Accounts.add_search_term(user1, %{text: "beep boop"})

      conn = get(conn, Routes.user_path(conn, :show, user1.id))
      assert html_response(conn, 200) =~ "beep boop"
    end

    test "GET /users/:id cannot see another user's profile", %{
      conn: conn,
      user1: user1,
      user2: user2
    } do
      conn = sign_in(conn, user1)

      conn = get(conn, Routes.user_path(conn, :show, user1.id))
      assert html_response(conn, 200)

      conn = get(conn, Routes.user_path(conn, :show, user2.id))
      assert conn.status == 302
      assert conn.halted == true
    end
  end

  describe "when user is not logged in" do
    test "GET /users/:id redirects", %{conn: conn} do
      conn1 = get(conn, Routes.user_path(conn, :show, "1"))
      assert html_response(conn1, 302) =~ "redirected"

      conn2 = get(conn, Routes.user_path(conn, :show, "2"))
      assert html_response(conn2, 302) =~ "redirected"
    end
  end

  test "GET /users/new", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
  end

  test "POST /users", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.user_path(conn, :create),
        user: %{
          credential: %{
            email: "jane@email.com",
            password: "password"
          }
        }
      )

    assert get_flash(conn, :info) =~ "Account created!"
    assert redirected_to(conn) == Routes.auth_path(conn, :request, "twitter")

    assert Accounts.get_user_by_email("jane@email.com") != nil
  end

  test "POST /users with invalid data", %{conn: conn} do
    invalid_user = %{"credential" => %{email: ""}}
    create_conn = post(conn, Routes.user_path(conn, :create), user: invalid_user)
    assert html_response(create_conn, 200) =~ "Oops, something went wrong!"
  end
end
