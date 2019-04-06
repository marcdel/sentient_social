defmodule SentientSocialWeb.UserControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Repo

  setup do
    Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})
    Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

    :ok
  end

  describe "when user is logged in" do
    setup %{conn: conn} do
      user = Accounts.get_user(2)
      conn = sign_in(conn, user)
      {:ok, %{signed_in_conn: conn, user: user}}
    end

    test "GET /users", %{signed_in_conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Marc"
      assert html_response(conn, 200) =~ "Jackie"
    end

    test "GET /users/:id", %{signed_in_conn: conn} do
      conn1 = get(conn, Routes.user_path(conn, :show, "1"))
      assert html_response(conn1, 200) =~ "Marc"
      refute html_response(conn1, 200) =~ "Jackie"

      conn2 = get(conn, Routes.user_path(conn, :show, "2"))
      refute html_response(conn2, 200) =~ "Marc"
      assert html_response(conn2, 200) =~ "Jackie"
    end
  end

  describe "when user is not logged in" do
    test "GET /users redirects", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "GET /users/:id redirects", %{conn: conn} do
      conn1 = get(conn, Routes.user_path(conn, :show, "1"))
      assert html_response(conn1, 302) =~ "redirected"

      conn2 = get(conn, Routes.user_path(conn, :show, "2"))
      assert html_response(conn2, 302) =~ "redirected"
    end
  end

  test "GET /users/new", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "Name"
    assert html_response(conn, 200) =~ "Username"
  end

  test "POST /users", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.user_path(conn, :create),
        user: %{
          "name" => "Jane",
          "username" => "janedoe",
          credential: %{
            email: "jane@email.com",
            password: "password"
          }
        }
      )

    assert get_flash(conn, :info) =~ "Jane created!"
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.user_path(conn, :show, id)

    conn = get(conn, Routes.user_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Jane"
  end

  test "POST /users with invalid data", %{conn: conn} do
    invalid_user = %{"name" => "Jane", "username" => ""}
    create_conn = post(conn, Routes.user_path(conn, :create), user: invalid_user)
    assert html_response(create_conn, 200) =~ "Oops, something went wrong!"
  end
end
