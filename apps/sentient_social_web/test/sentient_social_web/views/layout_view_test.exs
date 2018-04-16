defmodule SentientSocialWeb.LayoutViewTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocialWeb.LayoutView
  alias SentientSocial.Accounts

  test "current_user returns the currently logged in user", %{conn: conn} do
    {:ok, user} =
      Accounts.create_user(%{
        username: "testuser",
        name: "Test User",
        profile_image_url: "image.png",
        access_token: "token",
        access_token_secret: "secret"
      })

    current_user =
      conn
      |> sign_in(user)
      |> get("/")
      |> LayoutView.current_user()

    assert current_user.username == "testuser"
  end
end
