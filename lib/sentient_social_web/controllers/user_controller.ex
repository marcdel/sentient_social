defmodule SentientSocialWeb.UserController do
  use SentientSocialWeb, :controller

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocialWeb.Auth

  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, params) do
    if Auth.it_me?(conn, params) do
      user = Auth.current_user(conn)
      search_terms = Accounts.list_search_terms(user)
      render(conn, "show.html", user: user, search_terms: search_terms)
    else
      conn
      |> put_flash(:error, "That ain't you, friend")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> SentientSocialWeb.Auth.login(user)
        |> put_flash(:info, "#{user.username} created!")
        |> redirect(to: Routes.auth_path(conn, :request, "twitter"))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
