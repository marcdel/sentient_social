defmodule SentientSocialWeb.AuthenticateTest do
  @moduledoc """
  """
  use SentientSocialWeb.ConnCase, async: true

  test "user is redirected when current_user is not set", %{conn: conn} do
    conn = get(conn, dashboard_path(conn, :index))
    assert redirected_to(conn) == "/login"
  end

  test "user passes through when current_user is set", %{conn: conn} do
    conn =
      conn
      |> sign_in()
      |> get(dashboard_path(conn, :index))

    assert conn.status != 302
  end
end
