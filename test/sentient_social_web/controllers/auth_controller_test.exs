defmodule SentientSocialWeb.AuthControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocialWeb.Auth

  describe "when user is not logged in" do
    test "GET callback redirects", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :callback, "twitter"))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :error) == "You must be logged in to access that page"
    end
  end

  describe "when user is logged in" do
    setup %{conn: conn} do
      user = Fixtures.registered_user()

      conn = sign_in(conn, user)

      {:ok, user: user, conn: conn}
    end

    test "shows authentication failure message", %{conn: conn} do
      conn =
        conn
        |> assign(:ueberauth_failure, %{})
        |> get(Routes.auth_path(conn, :callback, "twitter"))

      assert get_flash(conn, :error) == "Failed to authenticate."
    end

    test "redirects to the user's profile page", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:ueberauth_auth, Fixtures.ueberauth_auth_response())
        |> get(Routes.auth_path(conn, :callback, "twitter"))

      assert get_flash(conn, :info) == "Successfully authenticated."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "saves the users auth tokens", %{conn: conn} do
      ueberauth_auth_response =
        Fixtures.ueberauth_auth_response(%{
          credentials: %{token: "token4321", secret: "secret4321"},
          info: %{nickname: "user1"}
        })

      user =
        conn
        |> assign(:ueberauth_auth, ueberauth_auth_response)
        |> get(Routes.auth_path(conn, :callback, "twitter"))
        |> Auth.current_user()

      assert %{
               username: "user1",
               provider: "twitter",
               token: "token4321",
               token_secret: "secret4321"
             } = user.token
    end
  end
end
