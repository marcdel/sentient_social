defmodule SentientSocialWeb.AuthTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocialWeb.Auth
  alias SentientSocial.Accounts

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
end
