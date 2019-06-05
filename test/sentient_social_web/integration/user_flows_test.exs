defmodule SentientSocialWeb.UserFlowsTest do
  use SentientSocialWeb.IntegrationCase, async: true
  import Mox

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  @tag :integration
  test "can log in a registered user", %{conn: conn} do
    user =
      Fixtures.registered_authorized_user(%{
        token: %{
          username: "dorkus"
        },
        credential: %{
          email: "user1@email.com",
          password: "password"
        }
      })

    conn
    |> get(Routes.session_path(conn, :new))
    |> follow_form(%{
      session: %{
        email: "user1@email.com",
        password: "password"
      }
    })
    |> assert_response(
      status: 200,
      html: "Welcome back, dorkus!",
      path: Routes.user_path(conn, :show, user.id)
    )
  end

  @tag :integration
  test "can add a new search term", %{conn: conn} do
    user = Fixtures.registered_authorized_user()

    conn
    |> sign_in(user)
    |> get(Routes.user_path(conn, :show, user.id))
    |> follow_form(%{
      text: "new search term"
    })
    |> assert_response(
      status: 200,
      html: "Search term added",
      path: Routes.user_path(conn, :show, user.id)
    )
  end

  @tag :integration
  test "can favorite tweets for random search terms", %{conn: conn} do
    user = Fixtures.registered_authorized_user()

    @twitter_client
    |> stub(:get_tuples, fn -> [] end)
    |> stub(:configure, fn _, _ -> :ok end)
    |> stub(:search, fn "new search term", _options -> [%{id: 1}] end)
    |> stub(:show, fn tweet_id, _options -> %{id: tweet_id} end)
    |> stub(:create_favorite, fn tweet_id, _options -> %{id: tweet_id} end)

    conn
    |> sign_in(user)
    |> get(Routes.user_path(conn, :show, user.id))
    |> follow_form(%{
      text: "new search term"
    })
    |> assert_response(
      status: 200,
      path: Routes.user_path(conn, :show, user.id)
    )
    |> follow_button("Favorite")
    |> assert_response(
      status: 200,
      html: "Favorited 1 tweet",
      path: Routes.user_path(conn, :show, user.id)
    )
  end
end
