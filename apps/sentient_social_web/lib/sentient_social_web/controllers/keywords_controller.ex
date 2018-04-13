defmodule SentientSocialWeb.KeywordsController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts

  @doc """
  Add a new keyword
  """
  @spec create(map, map) :: map
  def create(conn, %{"text" => text}) do
    current_user =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()

    case Accounts.create_keyword(%{text: text}, current_user) do
      {:ok, _} ->
        redirect(conn, to: "/")

      {:error, _error} ->
        conn
        |> put_flash(:error, "Unable to add keyword.")
        |> redirect(to: "/")
    end
  end
end
