defmodule SentientSocialWeb.SessionControllerTest do
  use SentientSocialWeb.ConnCase, async: true
  alias SentientSocial.Accounts

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
  end

  test "POST /sessions", %{conn: conn} do
    Accounts.register_user(%{
      id: 1,
      name: "Marc",
      username: "marcdel",
      credential: %{
        email: "marcdel@email.com",
        password: "password"
      }
    })

    conn =
      post(conn, Routes.session_path(conn, :create),
        session: %{"email" => "marcdel@email.com", "password" => "password"}
      )

    assert get_flash(conn, :info) =~ "Welcome back, Marc!"
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.user_path(conn, :show, id)
  end

  test "POST /sessions with invalid password", %{conn: conn} do
    invalid_session = %{
      "email" => "marcdel@email.com",
      "password" => "wrong password"
    }

    create_conn = post(conn, Routes.session_path(conn, :create), session: invalid_session)
    assert html_response(create_conn, 200) =~ "Oops, username or password were incorrect!"
  end

  test "DELETE /sessions", %{conn: conn} do
    {:ok, user} =
      Accounts.register_user(%{
        id: 1,
        name: "Marc",
        username: "marcdel",
        credential: %{
          email: "marcdel@email.com",
          password: "password"
        }
      })

    # user = %{id: 1}
    conn = sign_in(conn, user)

    conn = delete(conn, Routes.session_path(conn, :delete, user.id))

    assert get_flash(conn, :info) =~ "Logged out."
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end
end
