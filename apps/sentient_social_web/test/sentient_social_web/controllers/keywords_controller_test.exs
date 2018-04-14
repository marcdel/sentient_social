defmodule SentientSocialWeb.KeywordsControllerTest do
  use SentientSocialWeb.ConnCase
  alias SentientSocial.Accounts

  describe "POST /keywords" do
    test "adds a keyword for the current user", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "new keyword")

      assert user
             |> Accounts.list_keywords()
             |> Enum.map(fn x -> x.text end)
             |> Enum.member?("new keyword")
    end

    test "shows an error when keyword invalid", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "")

      assert Accounts.list_keywords(user) == []
    end

    test "returns error if keyword exists", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      {:ok, _} = Accounts.create_keyword(%{text: "keyword1"}, user)

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
      {:ok, user} =
        Accounts.create_user(%{
          username: "testuser",
          name: "Test User",
          profile_image_url: "image.png"
        })

      {:ok, keyword} = Accounts.create_keyword(%{text: "keyword1"}, user)

      conn
      |> sign_in(user)
      |> delete(keywords_path(conn, :delete, keyword.id))

      assert Accounts.list_keywords(user) == []
    end

    test "raises if unable to find keyword to be deleted", %{conn: conn} do
      {:ok, user1} =
        Accounts.create_user(%{
          username: "testuser1",
          name: "Test User 1",
          profile_image_url: "image.png"
        })

      {:ok, user2} =
        Accounts.create_user(%{
          username: "testuser2",
          name: "Test User 2",
          profile_image_url: "image.png"
        })

      {:ok, keyword} = Accounts.create_keyword(%{text: "keyword1"}, user1)

      assert_raise Ecto.NoResultsError, fn ->
        conn
        |> sign_in(user2)
        |> delete(keywords_path(conn, :delete, keyword.id))
      end
    end
  end
end
