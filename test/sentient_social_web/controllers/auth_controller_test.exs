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
      email: "user@email.com",
    },
    provider: :twitter
  }

  test "handles authentication failure", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_failure, %{})
      |> get("/auth/twitter/callback")

    assert get_flash(conn, :error) == "Failed to authenticate."
  end

  test "handles successful Twitter authentication", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/twitter/callback")

    assert get_flash(conn, :info) == "Successfully authenticated."
  end
end
