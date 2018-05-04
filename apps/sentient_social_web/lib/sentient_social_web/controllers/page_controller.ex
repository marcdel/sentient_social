defmodule SentientSocialWeb.PageController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts
  alias SentientSocial.Twitter

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

    automated_interactions =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Twitter.list_automated_interactions()

    conn
    |> assign(:keywords, keywords)
    |> assign(:muted_keywords, muted_keywords)
    |> assign(:automated_interactions, automated_interactions)
    |> render("index.html")
  end
end
