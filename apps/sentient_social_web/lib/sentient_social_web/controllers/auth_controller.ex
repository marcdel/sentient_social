defmodule SentientSocialWeb.AuthController do
  use SentientSocialWeb, :controller
  plug(Ueberauth)

  @doc """
  Handle successful ueberauth response
  """
  @spec callback(map, map) :: map
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.provider do
      :twitter ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, auth.info.email)
        |> redirect(to: "/")
    end
  end

  @doc """
  Handle unsuccessful ueberauth response
  """
  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end
end
