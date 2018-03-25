defmodule SentientSocialWeb.PageController do
  use SentientSocialWeb, :controller

  def index(conn, _params) do
    conn
    # |> put_flash(:info, "This is a warning")
    # |> put_flash(:error, "This is an error")
    |> render("index.html")
  end
end
