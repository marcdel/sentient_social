defmodule UserServerTest do
  use SentientSocial.DataCase

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{UserServer, User}

  @valid_user_attrs %{
    name: "John Doe",
    profile_image_url: "www.website.com/image.png",
    username: "johndoe",
    access_token: "token",
    access_token_secret: "secret"
  }

  @spec user_fixture(map) :: %User{}
  defp user_fixture(attrs) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Accounts.create_user()

    user
  end

  @spec generate_user_name() :: String.t()
  defp generate_user_name do
    "user-#{:rand.uniform(1_000_000)}"
  end

  test "spawning a user server process" do
    user = user_fixture(%{username: generate_user_name()})

    assert {:ok, _pid} = UserServer.start_link(user.username)
  end

  test "a user process is registered under a unique name" do
    user = user_fixture(%{username: generate_user_name()})

    assert {:ok, _pid} = UserServer.start_link(user.username)

    assert {:error, _reason} = UserServer.start_link(user.username)
  end
end
