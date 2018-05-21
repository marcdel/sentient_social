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
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> redirect(to: "/")
        |> halt

      current_user_id ->
        assign(conn, :current_user, current_user_id)
    end
  end
end
