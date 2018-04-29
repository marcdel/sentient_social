defmodule UserSupervisorTest do
  use SentientSocial.DataCase

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.{User, UserSupervisor, UserServer}

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

  describe "start_user" do
    test "spawns a user server process" do
      user = user_fixture(%{username: generate_user_name()})

      assert {:ok, _pid} = UserSupervisor.start_user(user.username)

      assert user.username
             |> UserServer.via_tuple()
             |> GenServer.whereis()
             |> Process.alive?()
    end

    test "returns an error if user is already started" do
      user = user_fixture(%{username: generate_user_name()})

      assert {:ok, pid} = UserSupervisor.start_user(user.username)

      assert {:error, {:already_started, ^pid}} = UserSupervisor.start_user(user.username)
    end
  end

  describe "stop_user" do
    test "terminates the process normally" do
      user = user_fixture(%{username: generate_user_name()})

      {:ok, _pid} = UserSupervisor.start_user(user.username)

      via = UserServer.via_tuple(user.username)

      assert :ok = UserSupervisor.stop_user(user.username)

      refute GenServer.whereis(via)
    end
  end
end
