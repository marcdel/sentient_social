defmodule SentientSocialWeb.AuthController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts
  plug(Ueberauth)

  @doc """
  Handle successful ueberauth response
  """
  @spec callback(map, map) :: map
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.provider do
      :twitter ->
        auth_user = auth.extra.raw_info.user

        {:ok, user} =
          Accounts.create_or_update_from_twitter(%{
            screen_name: auth_user["screen_name"],
            name: auth_user["name"],
            profile_image_url: auth_user["profile_image_url"]
          })

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user.username)
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
