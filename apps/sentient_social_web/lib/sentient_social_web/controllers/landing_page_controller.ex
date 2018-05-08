defmodule SentientSocialWeb.LandingPageController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts
  alias SentientSocial.Twitter

  plug(:put_layout, "landing_page.html")

  @spec index(map, map) :: map
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
