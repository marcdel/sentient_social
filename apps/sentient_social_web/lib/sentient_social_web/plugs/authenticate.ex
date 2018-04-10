defmodule SentientSocialWeb.Plug.Authenticate do
  @moduledoc """
  Ensure user is logged in, otherwise redirect them to login
  """
  import Plug.Conn
  import Phoenix.Controller

  @type opts :: binary | tuple | atom | integer | float | [opts] | %{opts => opts}

  @spec init(opts) :: opts
  def init(default), do: default

  @spec call(%Plug.Conn{}, opts) :: %Plug.Conn{}
  def call(conn, _default) do
    current_user = get_session(conn, :current_user)

    if current_user do
      assign(conn, :current_user, current_user)
    else
      conn
      |> redirect(to: "/auth/twitter")
      |> halt
    end
  end
end
