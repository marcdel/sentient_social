defmodule SentientSocialWeb.MutedKeywordsControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  import SentientSocial.Factory

  alias SentientSocial.Accounts

  describe "POST /muted_keywords" do
    test "adds a muted keyword for the current user", %{conn: conn} do
      user = insert(:user)

      conn
      |> sign_in(user)
      |> post(muted_keywords_path(conn, :create), text: "new muted keyword")

      user
      |> Accounts.list_keywords()
      |> Enum.each(fn x -> assert x.muted end)
    end

    test "shows an error when muted keyword invalid", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> sign_in(user)
        |> post(muted_keywords_path(conn, :create), text: "")

      assert Accounts.list_muted_keywords(user) == []
      assert redirected_to(conn) == "/dashboard"
      assert get_flash(conn, :error) == "Unable to add muted keyword."
    end

    test "returns error if muted keyword exists", %{conn: conn} do
      user = insert(:user)

      insert(:muted_keyword, %{text: "muted keyword1", user: user})

      conn =
        conn
        |> sign_in(user)
        |> post(muted_keywords_path(conn, :create), text: "muted keyword1")

      assert redirected_to(conn) == "/dashboard"
      assert get_flash(conn, :error) == "Unable to add muted keyword."
    end
  end

  describe "DELETE /muted_keywords" do
    test "removes the selected muted keyword", %{conn: conn} do
      user = insert(:user)

      muted_keyword = insert(:muted_keyword, %{text: "muted keyword1", user: user})

      conn
      |> sign_in(user)
      |> delete(muted_keywords_path(conn, :delete, muted_keyword.id))

      assert Accounts.list_muted_keywords(user) == []
    end

    test "raises if unable to find muted keyword to be deleted", %{conn: conn} do
      user1 = insert(:user, %{username: "testuser1"})
      user2 = insert(:user, %{username: "testuser2"})

      muted_keyword = insert(:muted_keyword, %{text: "muted keyword1", user: user1})

      assert_raise Ecto.NoResultsError, fn ->
        conn
        |> sign_in(user2)
        |> delete(muted_keywords_path(conn, :delete, muted_keyword.id))
      end
    end
  end
end
