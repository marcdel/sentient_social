defmodule SentientSocial.KeywordTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.Keyword

  describe "keywords" do
    alias SentientSocial.Accounts.Keyword

    @valid_attrs %{text: "some text"}
    @invalid_attrs %{text: nil}

    test "list_keywords/1 returns keywords for user" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)

      assert user
             |> Accounts.list_keywords()
             |> Repo.preload(:user) == [keyword]
    end

    test "get_keyword!/2 returns the keyword with given id" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)

      assert keyword.id
             |> Accounts.get_keyword!(user)
             |> Repo.preload(:user) == keyword
    end

    test "get_keyword!/2 returns an error if it doesn't belong to the user" do
      keyword = insert(:keyword)
      another_user = build(:user, %{username: "another_user"})
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_keyword!(keyword.id, another_user) end
    end

    test "find_keyword/2 returns keyword for a user by the text value" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)

      assert keyword.text
             |> Accounts.find_keyword(user)
             |> Repo.preload(:user) == keyword
    end

    test "find_keyword/2 returns an error if it doesn't belong to the user" do
      insert(:keyword)
      another_user = build(:user, %{username: "another_user"})
      assert Accounts.find_keyword("something", another_user) == nil
    end

    test "create_keyword/2 with valid data creates a keyword" do
      user = insert(:user)
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(@valid_attrs, user)
      assert keyword.text == "some text"
    end

    test "create_keyword/2 returns an error if keyword exists" do
      user1 = insert(:user, %{username: "user1"})
      user2 = insert(:user, %{username: "user2"})
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(%{text: "something"}, user1)
      assert {:ok, %Keyword{} = keyword} = Accounts.create_keyword(%{text: "something"}, user2)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_keyword(%{text: "something"}, user1)
    end

    test "create_keyword/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_keyword(@invalid_attrs, user)
    end

    test "delete_keyword/1 deletes the keyword" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)
      assert {:ok, %Keyword{}} = Accounts.delete_keyword(keyword)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_keyword!(keyword.id, user) end
    end
  end
end
