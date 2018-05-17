defmodule SentientSocialWeb.LoginController do
  use SentientSocialWeb, :controller

  plug(:put_layout, "login.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    current_user = get_session(conn, :current_user)

    if current_user do
      conn
      |> assign(:current_user, current_user)
      |> redirect(to: "/dashboard")
      |> halt
    else
      conn
      |> redirect(to: "/auth/twitter")
      |> halt
    end
  end
end
