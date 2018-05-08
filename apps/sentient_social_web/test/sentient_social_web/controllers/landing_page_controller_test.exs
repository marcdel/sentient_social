defmodule SentientSocialWeb.LandingPageControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  describe "GET /" do
    test "returns 200 status code", %{conn: conn} do
      assert conn
             |> get("/")
             |> html_response(200)
    end
  end
end
