defmodule UserSupervisorTest do
  use SentientSocial.DataCase

  import SentientSocial.Factory

  alias SentientSocial.Accounts.{UserSupervisor, UserServer}

  describe "start_user" do
    test "spawns a user server process" do
      user = build(:user)

      assert {:ok, _pid} = UserSupervisor.start_user(user.username)

      assert user.username
             |> UserServer.via_tuple()
             |> GenServer.whereis()
             |> Process.alive?()
    end

    test "returns an error if user is already started" do
      user = build(:user)

      assert {:ok, pid} = UserSupervisor.start_user(user.username)
      assert {:error, {:already_started, ^pid}} = UserSupervisor.start_user(user.username)
    end
  end

  describe "stop_user" do
    test "terminates the process normally" do
      user = build(:user)

      {:ok, _pid} = UserSupervisor.start_user(user.username)
      assert :ok = UserSupervisor.stop_user(user.username)

      via = UserServer.via_tuple(user.username)
      refute GenServer.whereis(via)
    end
  end
end
