defmodule SentientSocialWeb.SessionController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Auth.login_by_email_and_password(conn, email, password) do
      {:ok, conn} ->
        user = current_user(conn)

        conn
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: Routes.user_path(conn, :show, user.id))

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

  defp current_user(conn) do
    conn.assigns.current_user
  end
end
