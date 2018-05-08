defmodule SentientSocialWeb.KeywordIntegrationTest do
  use SentientSocialWeb.IntegrationCase, async: true

  test "user can add and remove a keyword", %{conn: conn} do
    conn
    |> sign_in()
    |> get(dashboard_path(conn, :index))
    |> assert_response(html: "Keywords", html: "Add a keyword")
    |> follow_form(%{text: "#codenewbie"})
    |> assert_response(
      status: 200,
      path: dashboard_path(conn, :index),
      html: "#codenewbie"
    )
    |> follow_link("close", method: :delete)
    |> refute_response(html: "#codenewbie")
  end

  test "user can add and remove a muted keyword", %{conn: conn} do
    conn
    |> sign_in()
    |> get(dashboard_path(conn, :index))
    |> assert_response(html: "Muted Keywords", html: "Add a muted keyword")
    |> follow_form(%{text: "#spam"})
    |> assert_response(
      status: 200,
      path: dashboard_path(conn, :index),
      html: "#spam"
    )
    |> follow_link("close", method: :delete)
    |> refute_response(html: "#spam")
  end
end
