defmodule SentientSocialWeb.AuthController do
  use SentientSocialWeb, :controller
  plug(Ueberauth)

  # If we authorized successfully, we'll handle each provider differently.
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # IO.inspect(auth)
    IO.inspect(auth.extra.raw_info.user)

    case auth.provider do
      :twitter ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, auth.info.email)
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end
end
