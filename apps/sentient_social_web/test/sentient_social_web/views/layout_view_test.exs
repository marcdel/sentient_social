defmodule SentientSocialWeb.LayoutViewTest do
  use SentientSocialWeb.ConnCase, async: true
  import SentientSocial.Factory

  alias SentientSocialWeb.LayoutView

  test "current_user returns the currently logged in user", %{conn: conn} do
    user = insert(:user, %{username: "testuser"})

    current_user =
      conn
      |> sign_in(user)
      |> get("/dashboard")
      |> LayoutView.current_user()

    assert current_user.username == "testuser"
  end
end
