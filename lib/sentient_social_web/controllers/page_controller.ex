defmodule SentientSocialWeb.PageController do
  use SentientSocialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
