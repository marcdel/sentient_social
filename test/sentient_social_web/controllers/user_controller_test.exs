defmodule SentientSocialWeb.UserControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  alias SentientSocial.Accounts.User
  alias SentientSocial.Repo

  setup do
    Repo.insert(%User{id: 1, name: "Marc", username: "marcdel"})
    Repo.insert(%User{id: 2, name: "Jackie", username: "jackie"})

    :ok
  end

  test "GET /users", %{conn: conn} do
    conn = get(conn, "/users")
    assert html_response(conn, 200) =~ "Marc"
    assert html_response(conn, 200) =~ "Jackie"
  end

  test "GET /users/:id", %{conn: conn} do
    conn1 = get(conn, "/users/1")
    assert html_response(conn1, 200) =~ "Marc"
    refute html_response(conn1, 200) =~ "Jackie"

    conn2 = get(conn, "/users/2")
    refute html_response(conn2, 200) =~ "Marc"
    assert html_response(conn2, 200) =~ "Jackie"
  end

  test "GET /users/new", %{conn: conn} do
    conn = get(conn, "/users/new")
    assert html_response(conn, 200) =~ "Name"
    assert html_response(conn, 200) =~ "Username"
  end

  test "POST /users", %{conn: conn} do
    create_conn = post(conn, Routes.user_path(conn, :create), user: %{"name" => "Jane", "username" => "janedoe"})
    assert get_flash(create_conn, :info) =~ "Jane created!"
    assert %{id: id} = redirected_params(create_conn)
    assert redirected_to(create_conn) == Routes.user_path(create_conn, :show, id)

    conn = get(conn, Routes.user_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Jane"
  end
end
