defmodule SentientSocialWeb.KeywordsControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  describe "POST /keywords" do
    @valid_user_attrs %{
      name: "John Doe",
      profile_image_url: "www.website.com/image.png",
      username: "johndoe",
      access_token: "token",
      access_token_secret: "secret"
    }

    @spec user_fixture(map) :: %User{}
    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Accounts.create_user()

      user
    end

    test "adds a keyword for the current user", %{conn: conn} do
      user = user_fixture()

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "new keyword")

      assert user
             |> Accounts.list_keywords()
             |> Enum.map(fn x -> x.text end)
             |> Enum.member?("new keyword")
    end

    test "shows an error when keyword invalid", %{conn: conn} do
      user = user_fixture()

      conn
      |> sign_in(user)
      |> post(keywords_path(conn, :create), text: "")

      assert Accounts.list_keywords(user) == []
    end

    test "returns error if keyword exists", %{conn: conn} do
      user = user_fixture()

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
      user = user_fixture()

      {:ok, keyword} = Accounts.create_keyword(%{text: "keyword1"}, user)

      conn
      |> sign_in(user)
      |> delete(keywords_path(conn, :delete, keyword.id))

      assert Accounts.list_keywords(user) == []
    end

    test "raises if unable to find keyword to be deleted", %{conn: conn} do
      user1 = user_fixture(username: "testuser1")
      user2 = user_fixture(username: "testuser2")

      {:ok, keyword} = Accounts.create_keyword(%{text: "keyword1"}, user1)

      assert_raise Ecto.NoResultsError, fn ->
        conn
        |> sign_in(user2)
        |> delete(keywords_path(conn, :delete, keyword.id))
      end
    end
  end
end
