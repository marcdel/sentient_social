defmodule SentientSocialWeb.UserRegistrationTest do
  use SentientSocialWeb.IntegrationCase, async: true

  @tag :integration
  test "can register a new user", %{conn: conn} do
    conn
    |> get(Routes.user_path(conn, :new))
    |> follow_form(%{
      user: %{
        name: "New User",
        username: "newuser",
        credential: %{
          email: "newuser@example.com",
          password: "password"
        }
      }
    })
    |> assert_response(status: 200, html: "New User created!")
  end
end
