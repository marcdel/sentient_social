defmodule SentientSocialWeb.PageControllerTest do
  use SentientSocialWeb.ConnCase
  alias SentientSocial.Accounts.User

  test "GET /", %{conn: conn} do
    conn =
      conn
      |> sign_in(%User{id: 1})
      |> get("/")

    assert html_response(conn, 200) =~ "Sentient Social"
    assert html_response(conn, 200) =~ "Log Out"
  end
end
