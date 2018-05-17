defmodule SentientSocialWeb.LoginControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  describe "index" do
    test "user is redirected to auth/twitter when current_user is not set", %{conn: conn} do
      conn = get(conn, login_path(conn, :index))
      assert redirected_to(conn) == "/auth/twitter"
    end

    test "user is redirected to /dashboard when current_user is set", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get(login_path(conn, :index))

      assert redirected_to(conn) == "/dashboard"
    end
  end
end
