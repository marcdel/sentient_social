defmodule SentientSocialWeb.PageControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn =
      conn
      |> sign_in()
      |> get("/")

    assert html_response(conn, 200) =~ "Sentient Social"
    assert html_response(conn, 200) =~ "Log Out"
  end
end
