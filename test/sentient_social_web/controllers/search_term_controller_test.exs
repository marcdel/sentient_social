defmodule SentientSocialWeb.SearchTermControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = Fixtures.registered_authorized_user()

    conn = sign_in(conn, user)

    {:ok, user: user, conn: conn}
  end

  describe "POST /search_terms" do
    test "adds the specified search term", %{conn: conn, user: user} do
      conn = post(conn, Routes.search_term_path(conn, :create), text: "test search term")
      assert get_flash(conn, :info) =~ "Search term added"
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "shows a message when there's an error adding the search term", %{conn: conn, user: user} do
      conn = post(conn, Routes.search_term_path(conn, :create), text: nil)
      assert get_flash(conn, :error) =~ "Whoops! That search term already exists."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end
  end
end
