defmodule SentientSocialWeb.LoginControllerTest do
  use SentientSocialWeb.ConnCase

  describe "index" do
    test "shows login button", %{conn: conn} do
      conn = get(conn, login_path(conn, :index))
      assert html_response(conn, 200) =~ "Log In"
    end
  end
end
