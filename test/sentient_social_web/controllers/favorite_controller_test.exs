defmodule SentientSocialWeb.FavoriteControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  import Mox

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  setup :verify_on_exit!

  setup %{conn: conn} do
    user = Fixtures.registered_authorized_user()

    conn = sign_in(conn, user)

    {:ok, user: user, conn: conn}
  end

  describe "POST /favorites" do
    test "shows a message saying no matching tweets were found", %{conn: conn, user: user} do
      expect(@twitter_client, :search, fn _query, [count: _count] -> [] end)

      conn = post(conn, Routes.favorite_path(conn, :create), search_term: "test search term")
      assert get_flash(conn, :error) =~ "No tweets found matching that search term."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "shows a message when there's an error favoriting tweets", %{conn: conn, user: user} do
      @twitter_client
      |> expect(:search, fn _query, [count: _count] -> [%{id: 1}] end)
      |> expect(:get_tuples, fn -> [] end)
      |> expect(:configure, fn _, _ -> :ok end)
      |> expect(:create_favorite, fn _, _ ->
        raise %ExTwitter.Error{message: "ExTwitter threw an error!"}
      end)

      conn = post(conn, Routes.favorite_path(conn, :create), search_term: "test search term")
      assert get_flash(conn, :error) =~ "We had some trouble favoriting that tweet for you."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "finds and favorites tweets with the specified text", %{conn: conn} do
      @twitter_client
      |> expect(:search, fn _query, [count: _count] -> [%{id: 1}] end)
      |> expect(:create_favorite, fn tweet_id, [] -> %{id: tweet_id} end)
      |> expect(:get_tuples, fn -> [] end)
      |> expect(:configure, fn _, _ -> :ok end)

      post(conn, Routes.favorite_path(conn, :create), search_term: "test search term")
    end

    test "does not favorite tweets that have already been favorited", %{conn: conn, user: user} do
      @twitter_client
      |> expect(:search, fn _query, [count: _count] -> [%{id: 1, favorited: true}] end)

      conn = post(conn, Routes.favorite_path(conn, :create), search_term: "test search term")
      assert get_flash(conn, :error) =~ "No tweets found matching that search term."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "displays the number of tweets favorited", %{conn: conn, user: user} do
      @twitter_client
      |> expect(:search, fn _query, [count: _count] -> [%{id: 1}] end)
      |> expect(:create_favorite, fn tweet_id, [] -> %{id: tweet_id} end)
      |> expect(:get_tuples, fn -> [] end)
      |> expect(:configure, fn _, _ -> :ok end)

      conn = post(conn, Routes.favorite_path(conn, :create), search_term: "test search term")
      assert get_flash(conn, :info) =~ "Favorited 1 tweet"
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end
  end
end
