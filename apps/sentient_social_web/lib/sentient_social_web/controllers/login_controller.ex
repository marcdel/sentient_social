defmodule SentientSocialWeb.LoginController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts

  plug(:put_layout, "external.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec create(map, map) :: map
  def create(conn, %{"email" => ""}) do
    conn
    |> put_flash(:error, "Please enter your email address.")
  end

  def create(conn, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        Accounts.create_user(%{email: email})

      user ->
        user
    end

    conn
    |> redirect(to: "/auth/twitter")
    |> halt
  end
end
