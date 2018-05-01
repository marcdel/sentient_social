defmodule SentientSocialWeb.KeywordsControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  import SentientSocial.Factory

  alias SentientSocial.Accounts

  describe "POST /keywords" do
    test "adds a keyword for the current user", %{conn: conn} do
      user = insert(:user)

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "new keyword")

      assert user
             |> Accounts.list_keywords()
             |> Enum.map(fn x -> x.text end)
             |> Enum.member?("new keyword")
    end

    test "shows an error when keyword invalid", %{conn: conn} do
      user = insert(:user)

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "")

      assert Accounts.list_keywords(user) == []
    end

    test "returns error if keyword exists", %{conn: conn} do
      user = insert(:user)

      insert(:keyword, %{text: "keyword1", user: user})

      conn =
        conn
        |> sign_in(user)
        |> post(keywords_path(conn, :create), text: "keyword1")

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) == "Unable to add keyword."
    end
  end

  describe "DELETE /keywords" do
    test "removes the selected keyword", %{conn: conn} do
      user = insert(:user)

      keyword = insert(:keyword, %{text: "keyword1", user: user})

      conn
      |> sign_in(user)
      |> delete(keywords_path(conn, :delete, keyword.id))

      assert Accounts.list_keywords(user) == []
    end

    test "raises if unable to find keyword to be deleted", %{conn: conn} do
      user1 = insert(:user, %{username: "testuser1"})
      user2 = insert(:user, %{username: "testuser2"})

      keyword = insert(:keyword, %{text: "keyword1", user: user1})

      assert_raise Ecto.NoResultsError, fn ->
        conn
        |> sign_in(user2)
        |> delete(keywords_path(conn, :delete, keyword.id))
      end
    end
  end
end
