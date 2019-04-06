defmodule SentientSocialWeb.UserFlowsTest do
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

  @tag :integration
  test "can log in a registered user", %{conn: conn} do
    SentientSocial.Accounts.register_user(%{
      id: 1,
      name: "Marc",
      username: "marcdel",
      credential: %{
        email: "marcdel@email.com",
        password: "password"
      }
    })

    conn
    |> get(Routes.session_path(conn, :new))
    |> follow_form(%{
      session: %{
        email: "marcdel@email.com",
        password: "password"
      }
    })
    |> assert_response(status: 200, html: "Welcome back, Marc!")
  end
end
