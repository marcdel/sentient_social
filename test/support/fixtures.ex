defmodule SentientSocial.Fixtures do
  @default_ueberauth_response %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      token: "token4321",
      secret: "secret4321"
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        token: '1234abcd',
        user: %{
          "protected" => false,
          "id_str" => "1234567",
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
            "description" => %{
              "urls" => []
            },
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
          "favourites_count" => 5_318,
          "geo_enabled" => false,
          "profile_image_url_https" => "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
          "profile_use_background_image" => true,
          "time_zone" => "Pacific Time (US & Canada)",
          "profile_banner_url" => "http://pbs.twimg.com/profile_images/123456789_normal.jpg",
          "follow_request_sent" => false,
          "screen_name" => "user"
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

  def ueberauth_auth_response(attrs \\ %{}) do
    Map.merge(@default_ueberauth_response, attrs)
  end
end
