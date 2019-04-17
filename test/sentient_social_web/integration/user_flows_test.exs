defmodule SentientSocialWeb.UserFlowsTest do
  use SentientSocialWeb.IntegrationCase, async: true
  import Mox

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  @tag :integration
  test "can log in a registered user", %{conn: conn} do
    user =
      Fixtures.registered_authorized_user(%{
        name: "Dorkus",
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
      html: "Welcome back, Dorkus!",
      path: Routes.user_path(conn, :show, user.id)
    )
  end

  @tag :integration
  test "can favorite tweets for random search terms", %{conn: conn} do
    user = Fixtures.registered_authorized_user()

    @twitter_client
    |> expect(:search, fn _query, [count: _count] -> [%{id: 1}] end)
    |> expect(:create_favorite, fn tweet_id, [] -> %{id: tweet_id} end)
    |> expect(:get_tuples, fn -> [] end)
    |> expect(:configure, fn _, _ -> :ok end)

    conn
    |> sign_in(user)
    |> get(Routes.user_path(conn, :show, user.id))
    |> follow_form(%{
      search_term: "things and stuff"
    })
    |> assert_response(
      status: 200,
      html: "Favorited 1 tweet",
      path: Routes.user_path(conn, :show, user.id)
    )
  end
end
