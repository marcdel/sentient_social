defmodule SentientSocialWeb.LoginController do
  use SentientSocialWeb, :controller

  plug(:put_layout, "login.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
