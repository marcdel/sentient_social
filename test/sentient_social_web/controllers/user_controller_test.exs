defmodule SentientSocialWeb.UserControllerTest do
  use SentientSocialWeb.ConnCase

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
end
