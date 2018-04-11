defmodule SentientSocialWeb.LayoutView do
  use SentientSocialWeb, :view
  import Plug.Conn

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  @doc """
  Returns the currently logged in user
  """
  @spec current_user(map) :: %User{}
  def current_user(conn) do
    user_id = get_session(conn, :current_user)
    Accounts.get_user!(user_id)
  end
end
