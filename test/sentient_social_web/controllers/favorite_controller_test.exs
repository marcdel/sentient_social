defmodule SentientSocialWeb.FavoriteControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocial.Accounts
  import Mox

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  setup :verify_on_exit!

  describe "POST /favorites" do
    setup %{conn: conn} do
      {:ok, user} =
        Fixtures.registered_authorized_user()
        |> Accounts.add_search_term(%{text: "test search term"})

      @twitter_client
      |> stub(:get_tuples, fn -> [] end)
      |> stub(:configure, fn _, _ -> :ok end)
      |> stub(:search, fn "test search term", _options -> [%{id: 1}] end)
      |> stub(:show, fn tweet_id, _options -> %{id: tweet_id} end)
      |> stub(:create_favorite, fn tweet_id, _options -> %{id: tweet_id} end)

      conn = sign_in(conn, user)

      {:ok, user: user, conn: conn}
    end

    test "shows a message saying no matching tweets were found", %{conn: conn, user: user} do
      expect(@twitter_client, :search, fn _query, _options -> [] end)

      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :error) =~ "No tweets found matching that search term."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "shows a message when there's an error favoriting tweets", %{conn: conn, user: user} do
      expect(@twitter_client, :create_favorite, fn _tweet_id, _options ->
        raise %ExTwitter.Error{message: "ExTwitter threw an error!"}
      end)

      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :error) =~ "We had some trouble favoriting that tweet for you."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "does not favorite tweets that have already been favorited", %{conn: conn, user: user} do
      stub(@twitter_client, :search, fn _query, _options -> [%{id: 1, favorited: true}] end)
      stub(@twitter_client, :show, fn tweet_id, _options -> %{id: tweet_id, favorited: true} end)

      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :error) =~ "No new tweets found matching that search term."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "finds and favorites tweets with the specified text", %{conn: conn} do
      @twitter_client
      |> stub(:search, fn _query, _options -> [%{id: 1}, %{id: 2}] end)
      |> expect(:create_favorite, fn 1, _options -> %{id: 1} end)
      |> expect(:create_favorite, fn 2, _options -> %{id: 2} end)

      post(conn, Routes.favorite_path(conn, :create))
    end

    test "displays the number of tweets favorited", %{conn: conn} do
      stub(@twitter_client, :search, fn _query, _options -> [%{id: 1}] end)
      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :info) =~ "Favorited 1 tweets"

      stub(@twitter_client, :search, fn _query, _options -> [%{id: 1}, %{id: 2}] end)
      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :info) =~ "Favorited 2 tweets"

      stub(@twitter_client, :search, fn _query, _options -> [%{id: 1}, %{id: 2}, %{id: 3}] end)
      conn = post(conn, Routes.favorite_path(conn, :create))
      assert get_flash(conn, :info) =~ "Favorited 3 tweets"
    end
  end
end
