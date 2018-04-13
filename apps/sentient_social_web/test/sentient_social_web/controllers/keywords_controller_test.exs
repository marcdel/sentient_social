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
  end
end
