defmodule UserServerTest do
  use SentientSocial.DataCase
  import Mox

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{User, UserServer}

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  setup :verify_on_exit!

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
    username = generate_user_name()

    assert {:ok, _pid} = UserServer.start_link(username)
  end

  test "a user process is registered under a unique name" do
    username = generate_user_name()

    assert {:ok, _pid} = UserServer.start_link(username)

    assert {:error, _reason} = UserServer.start_link(username)
  end

  describe "user_pid" do
    test "returns a PID if it has been registered" do
      username = generate_user_name()

      {:ok, pid} = UserServer.start_link(username)

      assert ^pid = UserServer.user_pid(username)
    end

    test "returns nil if the user process does not exist" do
      refute UserServer.user_pid("nonexistent-user")
    end
  end

  describe "favorite_some_tweets" do
    test "searches for and likes tweets" do
      username = generate_user_name()
      user = user_fixture(%{username: username})
      Accounts.create_keyword(%{text: "keyword1"}, user)

      {:ok, pid} = UserServer.start_link(username)

      expect(@twitter_client, :search, 1, fn _, _ -> [%Tweet{}, %Tweet{}, %Tweet{}, %Tweet{}] end)
      expect(@twitter_client, :create_favorite, 4, fn _id -> {:ok, %Tweet{}} end)
      allow(@twitter_client, self(), pid)

      username |> UserServer.favorite_some_tweets()

      # Wait for Kernel.send/2 which is async
      :timer.sleep(20)
    end
  end
end
