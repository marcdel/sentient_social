defmodule SentientSocial.KeywordTest do
  use SentientSocial.DataCase

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{User, Keyword}

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

  describe "keywords" do
    alias SentientSocial.Accounts.Keyword

    @valid_attrs %{text: "some text"}
    @invalid_attrs %{text: nil}

    defp keyword_fixture do
      user = user_fixture()
      keyword_fixture(%{}, user)
    end

    defp keyword_fixture(user) do
      keyword_fixture(%{}, user)
    end

    defp keyword_fixture(attrs, user) do
      {:ok, keyword} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_keyword(user)

      keyword
    end

    test "list_keywords/1 returns keywords for user" do
      user = user_fixture()
      keyword = keyword_fixture(user)
      assert Accounts.list_keywords(user) == [keyword]
    end

    test "get_keyword!/2 returns the keyword with given id" do
      user = user_fixture()
      keyword = keyword_fixture(user)
      assert Accounts.get_keyword!(keyword.id, user) == keyword
    end

    test "get_keyword!/2 returns an error if it doesn't belong to the user" do
      keyword = keyword_fixture()
      another_user = user_fixture(%{username: "another_user"})
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_keyword!(keyword.id, another_user) end
    end

    test "find_keyword/2 returns keyword for a user by the text value" do
      user = user_fixture()
      keyword = keyword_fixture(user)
      assert Accounts.find_keyword(keyword.text, user) == keyword
    end

    test "find_keyword/2 returns an error if it doesn't belong to the user" do
      keyword_fixture()
      another_user = user_fixture(%{username: "another_user"})
      assert Accounts.find_keyword("something", another_user) == nil
    end

    test "create_keyword/2 with valid data creates a keyword" do
      user = user_fixture()
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(@valid_attrs, user)
      assert keyword.text == "some text"
    end

    test "create_keyword/2 returns an error if keyword exists" do
      user1 = user_fixture(%{username: "user1"})
      user2 = user_fixture(%{username: "user2"})
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(%{text: "something"}, user1)
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(%{text: "something"}, user2)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_keyword(%{text: "something"}, user1)
    end

    test "create_keyword/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.create_keyword(@invalid_attrs, user)
    end

    test "delete_keyword/1 deletes the keyword" do
      user = user_fixture()
      keyword = keyword_fixture(user)
      assert {:ok, %Keyword{}} = Accounts.delete_keyword(keyword)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_keyword!(keyword.id, user) end
    end
  end
end
