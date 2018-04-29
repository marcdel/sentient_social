defmodule UserLoaderTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{UserLoader, UserServer, User}

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

  test "starts a user server for each user in the database" do
    user1 = user_fixture(%{username: generate_user_name()})
    user2 = user_fixture(%{username: generate_user_name()})
    user3 = user_fixture(%{username: generate_user_name()})

    assert :ok = UserLoader.load()

    assert UserServer.user_pid(user1.username) != nil
    assert UserServer.user_pid(user2.username) != nil
    assert UserServer.user_pid(user3.username) != nil
  end
end
