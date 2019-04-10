defmodule SentientSocialWeb.AuthController do
  use SentientSocialWeb, :controller
  alias SentientSocialWeb.Auth
  plug(Ueberauth)
  plug :authenticate_user when action in [:callback]

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.provider do
      :twitter ->
        %{id: user_id} = Auth.current_user(conn)

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: Routes.user_path(conn, :show, user_id))
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end
end
