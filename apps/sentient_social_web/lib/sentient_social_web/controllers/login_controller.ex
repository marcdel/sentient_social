defmodule SentientSocialWeb.LoginController do
  use SentientSocialWeb, :controller

  plug(:put_layout, "login.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> redirect(to: "/auth/twitter")
        |> halt

      current_user_id ->
        conn
        |> assign(:current_user, current_user_id)
        |> redirect(to: "/dashboard")
        |> halt
    end
  end
end
