defmodule SentientSocialWeb.AuthControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.UserServer

  test "handles authentication failure", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_failure, %{})
      |> get("/auth/twitter/callback")

    assert get_flash(conn, :error) == "Failed to authenticate."
    assert redirected_to(conn, 302) == "/"
  end

  @ueberauth_auth %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      expires: nil,
      expires_at: nil,
      other: %{},
      refresh_token: nil,
      scopes: [],
      secret: 'secret',
      token: 'token',
      token_type: nil
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        token: '1234abcd',
        user: %{
          "protected" => false,
          "id_str" => "12345",
          "friends_count" => 519,
          "has_extended_profile" => false,
          "followers_count" => 163,
          "following" => false,
          "default_profile" => false,
          "translator_type" => "none",
          "profile_sidebar_fill_color" => "252429",
          "id" => 1_234_567,
          "profile_image_url" => "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
          "profile_link_color" => "2FC2EF",
          "is_translation_enabled" => false,
          "verified" => false,
          "utc_offset" => -25_200,
          "profile_sidebar_border_color" => "181A1E",
          "statuses_count" => 3_788,
          "profile_text_color" => "666666",
          "is_translator" => false,
          "lang" => "en",
          "profile_background_image_url_https" =>
            "https://abs.twimg.com/images/themes/theme9/bg.gif",
          "listed_count" => 4,
          "location" => "Washington DC",
          "contributors_enabled" => false,
          "profile_background_image_url" => "http://abs.twimg.com/images/themes/theme9/bg.gif",
          "created_at" => "Thu Mar 22 09:25:47 +0000 2007",
          "name" => "User's Full Name",
          "profile_background_color" => "1A1B1F",
          "notifications" => false,
          "entities" => %{
            "description" => %{"urls" => []},
            "url" => %{
              "urls" => [
                %{
                  "display_url" => "website.com",
                  "expanded_url" => "http://www.website.com",
                  "indices" => [0, 23],
                  "url" => "https://t.co/abc123"
                }
              ]
            }
          },
          "url" => "https://t.co/abc123",
          "profile_background_tile" => false,
          "default_profile_image" => false,
          "description" => "User description",
          "favourites_count" => 5318,
          "geo_enabled" => false,
          "profile_image_url_https" => "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
          "profile_use_background_image" => true,
          "time_zone" => "Pacific Time (US & Canada)",
          "profile_banner_url" => "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
          "follow_request_sent" => false,
          "screen_name" => "handle"
        }
      }
    },
    info: %Ueberauth.Auth.Info{
      description: "User description",
      email: "user@email.com",
      first_name: nil,
      image: "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
      last_name: nil,
      location: nil,
      name: "User's Full Name",
      nickname: "handle",
      phone: nil,
      urls: %{
        Twitter: "https://twitter.com/handle",
        Website: "https://t.co/123abc"
      }
    },
    provider: :twitter
  }

  test "handles successful Twitter authentication", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/twitter/callback")

    assert get_flash(conn, :info) == "Successfully authenticated."
    assert redirected_to(conn, 302) == "/dashboard"
  end

  test "creates or updates a user on log in", %{conn: conn} do
    conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/twitter/callback")

    user = Accounts.get_user_by_username("handle")
    assert user.username == "handle"
    assert user.name == "User's Full Name"
    assert user.profile_image_url == "http://pbs.twimg.com/profile_images/123456789_normal.jpg"
    assert user.access_token == "token"
    assert user.access_token_secret == "secret"
  end

  test "starts a user server process when a user logs in", %{conn: conn} do
    conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/twitter/callback")

    username = @ueberauth_auth.extra.raw_info.user["screen_name"]
    refute nil == UserServer.user_pid(username)
  end

  test "handles user sign out", %{conn: conn} do
    conn = delete(conn, "/auth/logout")

    assert get_flash(conn, :info) == "Successfully signed out."
    assert redirected_to(conn, 302) == "/"
  end
end
