defmodule SentientSocialWeb.LandingPageController do
  use SentientSocialWeb, :controller

  plug(:put_layout, "external.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
