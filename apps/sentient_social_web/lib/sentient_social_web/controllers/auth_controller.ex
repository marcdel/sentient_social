defmodule SentientSocialWeb.AuthController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.UserSupervisor
  plug(Ueberauth)

  @doc """
  Drop the current user's session
  """
  @spec logout(map, map) :: map
  def logout(conn, _params) do
    conn
    |> put_flash(:info, "Successfully signed out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  Handle successful ueberauth response
  """
  @spec callback(map, map) :: map
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.provider do
      :twitter ->
        auth_user = auth.extra.raw_info.user
        credentials = auth.credentials

        {:ok, user} =
          Accounts.create_or_update_from_twitter(%{
            screen_name: auth_user["screen_name"],
            name: auth_user["name"],
            profile_image_url: auth_user["profile_image_url"],
            access_token: credentials.token,
            access_token_secret: credentials.secret
          })

        UserSupervisor.start_user(user.username)

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user.id)
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
