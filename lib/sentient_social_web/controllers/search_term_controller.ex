defmodule SentientSocialWeb.SearchTermController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  alias SentientSocial.Accounts

  plug :authenticate_user when action in [:create]

  def create(conn, %{"text" => text}) do
    user = Auth.current_user(conn)

    case Accounts.add_search_term(user, %{text: text}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Search term added")
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "We had some trouble adding that search term for you.")
        |> redirect(to: Routes.user_path(conn, :show, Auth.current_user(conn).id))
    end
  end
end
