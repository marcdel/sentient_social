defmodule SentientSocialWeb.PageControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  import SentientSocial.Factory

  describe "GET /" do
    test "shows log out link", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get("/")

      assert html_response(conn, 200) =~ "Log Out"
    end

    test "lists current user's keywords", %{conn: conn} do
      user = insert(:user)
      insert(:keyword, %{text: "keyword1", user: user})
      insert(:keyword, %{text: "keyword2", user: user})

      conn =
        conn
        |> sign_in(user)
        |> get("/")

      assert html_response(conn, 200) =~ "Keywords"
      assert html_response(conn, 200) =~ "keyword1"
      assert html_response(conn, 200) =~ "keyword2"
    end
  end
end
