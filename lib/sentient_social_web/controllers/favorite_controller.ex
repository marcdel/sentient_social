defmodule SentientSocialWeb.FavoriteController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  alias SentientSocial.{Accounts, Twitter}

  plug :authenticate_user when action in [:create]

  def create(conn, _) do
    user = Auth.current_user(conn)

    result =
      user
      |> Accounts.list_search_terms()
      |> Enum.map(fn term -> term.text end)
      |> Twitter.favorite_tweets_by_search_terms(user)

    conn
    |> put_error_message(result)
    |> put_success_message(result)
    |> redirect(to: Routes.user_path(conn, :show, user.id))
  end

  defp put_error_message(conn, %{error_count: 0}), do: conn

  defp put_error_message(conn, %{error_messages: error_messages}) do
    put_flash(conn, :error, Enum.join(error_messages, "\n"))
  end

  defp put_success_message(conn, %{success_count: 0}), do: conn

  defp put_success_message(conn, %{success_count: success_count}) do
    put_flash(conn, :info, "Favorited #{success_count} tweets")
  end
end
