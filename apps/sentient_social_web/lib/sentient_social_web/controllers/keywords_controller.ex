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
        redirect(conn, to: "/dashboard")

      {:error, _error} ->
        conn
        |> put_flash(:error, "Unable to add keyword.")
        |> redirect(to: "/dashboard")
    end
  end

  @doc """
  Removes the selected keyword
  """
  @spec delete(map, map) :: map
  def delete(conn, %{"id" => id}) do
    current_user =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()

    keyword = Accounts.get_keyword!(id, current_user)
    {:ok, _} = Accounts.delete_keyword(keyword)
    redirect(conn, to: "/dashboard")
  end
end
