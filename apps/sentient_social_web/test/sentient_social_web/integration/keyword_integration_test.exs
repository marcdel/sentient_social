defmodule SentientSocialWeb.KeywordIntegrationTest do
  use SentientSocialWeb.IntegrationCase, async: true

  test "user can add and remove a keyword", %{conn: conn} do
    conn
    |> sign_in()
    |> get(page_path(conn, :index))
    |> assert_response(html: "Keywords", html: "Add a keyword")
    |> follow_form(%{text: "#codenewbie"})
    |> assert_response(
      status: 200,
      path: page_path(conn, :index),
      html: "#codenewbie"
    )
    |> follow_link("close", method: :delete)
    |> refute_response(html: "#codenewbie")
  end
end
