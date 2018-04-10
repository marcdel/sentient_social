defmodule SentientSocialWeb.AuthenticateTest do
  @moduledoc """
  """
  use SentientSocialWeb.ConnCase
  alias SentientSocial.Accounts.User

  test "user is redirected when current_user is not set", %{conn: conn} do
    conn = get(conn, page_path(conn, :index))

    assert redirected_to(conn) == "/auth/twitter"
  end

  test "user passes through when current_user is set", %{conn: conn} do
    user = %User{id: 1}

    conn =
      conn
      |> sign_in(user)
      |> get(page_path(conn, :index))

    assert conn.status != 302
  end
end
