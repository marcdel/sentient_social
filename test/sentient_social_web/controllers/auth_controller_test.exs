defmodule SentientSocialWeb.AuthControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  @ueberauth_auth %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      token: "abcd4321",
      token_type: nil
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        user: %{
          "id_str" => "1234567",
          "id" => 1_234_567,
          "name" => "User's Full Name",
          "screen_name" => "user"
        }
      }
    },
    info: %Ueberauth.Auth.Info{
      email: "user@email.com"
    },
    provider: :twitter
  }

  describe "when user is not logged in" do
    test "GET callback redirects", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :callback, "twitter"))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :error) == "You must be logged in to access that page"
    end
  end

  describe "when user is logged in" do
    setup %{conn: conn} do
      {:ok, user} =
        SentientSocial.Accounts.register_user(%{
          id: 1,
          name: "Marc",
          username: "marcdel",
          credential: %{
            email: "marcdel@email.com",
            password: "password"
          }
        })

      conn = sign_in(conn, user)

      {:ok, user: user, conn: conn}
    end

    test "handles authentication failure", %{conn: conn} do
      conn =
        conn
        |> assign(:ueberauth_failure, %{})
        |> get(Routes.auth_path(conn, :callback, "twitter"))

      assert get_flash(conn, :error) == "Failed to authenticate."
    end

    test "handles successful Twitter authentication", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:ueberauth_auth, @ueberauth_auth)
        |> get(Routes.auth_path(conn, :callback, "twitter"))

      assert get_flash(conn, :info) == "Successfully authenticated."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end
  end
end
