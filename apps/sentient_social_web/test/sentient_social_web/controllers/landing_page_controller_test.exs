defmodule SentientSocialWeb.LandingPageControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  describe "GET /" do
    test "returns 200 status code", %{conn: conn} do
      assert conn
             |> get("/")
             |> html_response(200)
    end

    test "shows login button when not logged in", %{conn: conn} do
      conn = get(conn, landing_page_path(conn, :index))
      assert html_response(conn, 200) =~ "Log In"
    end

    test "shows register button when not logged in", %{conn: conn} do
      conn = get(conn, landing_page_path(conn, :index))
      assert html_response(conn, 200) =~ "Register"
    end

    test "shows dashboard button when logged in", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get(landing_page_path(conn, :index))

      assert html_response(conn, 200) =~ "Dashboard"
    end

    test "shows log out button when logged in", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get(landing_page_path(conn, :index))

      assert html_response(conn, 200) =~ "Log Out"
    end
  end
end
