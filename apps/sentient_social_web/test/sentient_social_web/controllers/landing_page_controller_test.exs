defmodule SentientSocialWeb.LandingPageControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  describe "GET /" do
    test "returns 200 status code", %{conn: conn} do
      assert conn
             |> get("/")
             |> html_response(200)
    end

    test "shows login button", %{conn: conn} do
      conn = get(conn, landing_page_path(conn, :index))
      assert html_response(conn, 200) =~ "Log In"
    end
  end
end
