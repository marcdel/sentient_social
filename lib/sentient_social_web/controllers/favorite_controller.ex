defmodule SentientSocialWeb.FavoriteController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  alias SentientSocial.{Accounts, Twitter}

  plug :authenticate_user when action in [:create]

  def create(conn, _) do
    user = Auth.current_user(conn)
    [%{text: search_term} | _] = Accounts.list_search_terms(user)

    case Twitter.favorite_tweets_by_search_term(search_term, user) do
      %{error_count: 0, success_count: success_count} ->
        conn
        |> put_flash(:info, "Favorited #{success_count} tweets")
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      %{error_messages: error_messages} ->
        conn
        |> put_flash(:error, Enum.join(error_messages, "\n"))
        |> redirect(to: Routes.user_path(conn, :show, Auth.current_user(conn).id))
    end
  end
end
