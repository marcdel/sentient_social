defmodule SentientSocialWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias SentientSocial.Accounts

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import SentientSocialWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint SentientSocialWeb.Endpoint

      @spec sign_in(map, %{id: integer}) :: map
      def sign_in(conn, user) do
        conn
        |> bypass_through(SentientSocialWeb.Router, :browser)
        |> get("/")
        |> put_session(:current_user, user.id)
        |> send_resp(:ok, "")
        |> recycle()
      end

      def sign_in(conn) do
        {:ok, user} =
          Accounts.create_user(%{
            username: "testuser",
            name: "Test User",
            profile_image_url: "image.png"
          })

        sign_in(conn, user)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SentientSocial.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SentientSocial.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
