defmodule SentientSocialWeb.PageControllerTest do
  use SentientSocialWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Sentient Social"
    assert html_response(conn, 200) =~ "Log In"
  end
end
