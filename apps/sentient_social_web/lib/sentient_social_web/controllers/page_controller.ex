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

    muted_keywords =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Accounts.list_muted_keywords()

    conn
    |> assign(:keywords, keywords)
    |> assign(:muted_keywords, muted_keywords)
    |> render("index.html")
  end
end
