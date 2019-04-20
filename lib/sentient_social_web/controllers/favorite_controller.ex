defmodule SentientSocialWeb.FavoriteController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  alias SentientSocial.{Accounts, Twitter}

  plug :authenticate_user when action in [:create]

  def create(conn, _) do
    user = Auth.current_user(conn)
    [%{text: search_term} | _] = Accounts.list_search_terms(user)

    case Twitter.favorite_tweet_by_search_term(user, search_term) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "Favorited 1 tweet")
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: Routes.user_path(conn, :show, Auth.current_user(conn).id))
    end
  end
end
