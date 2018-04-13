defmodule SentientSocialWeb.PageController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts

  @spec index(map, map) :: map
  def index(conn, _params) do
    keywords =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Accounts.list_keywords()

    conn
    |> assign(:keywords, keywords)
    |> render("index.html")
  end
end
