defmodule SentientSocialWeb.PageControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocial.Accounts

  describe "GET /" do
    test "shows log out link", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get("/")

      assert html_response(conn, 200) =~ "Log Out"
    end

    test "lists current user's keywords", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      Accounts.create_keyword(%{text: "keyword1"}, user)
      Accounts.create_keyword(%{text: "keyword2"}, user)

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
