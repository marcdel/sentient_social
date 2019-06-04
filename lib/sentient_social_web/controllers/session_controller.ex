defmodule SentientSocialWeb.SessionController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  alias SentientSocial.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Auth.login_by_email_and_password(conn, email, password) do
      {:ok, conn} ->
        user = Auth.current_user(conn)
        redirect_to_user(conn, user)

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Oops, username or password were incorrect!")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp redirect_to_user(conn, %{token: nil}) do
    redirect(conn, to: Routes.auth_path(conn, :request, "twitter"))
  end

  defp redirect_to_user(conn, user) do
    conn
    |> put_flash(:info, "Welcome back, #{User.username(user)}!")
    |> redirect(to: Routes.user_path(conn, :show, user.id))
  end
end
