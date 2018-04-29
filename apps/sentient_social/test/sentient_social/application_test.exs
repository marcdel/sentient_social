defmodule ApplicationTest do
  use ExUnit.Case, async: true

  alias SentientSocial.Accounts.{UserRegistry, UserLoaderSupervisor}

  test "starts the Repo, the UserRegistry, and the UserLoaderSupervisor" do
    pid = Process.whereis(SentientSocial.Supervisor)
    assert Process.alive?(pid)

    assert [
             {UserLoaderSupervisor, _, :supervisor, [UserLoaderSupervisor]},
             {UserRegistry, _, :supervisor, [Registry]},
             {SentientSocial.Repo, _, :supervisor, [SentientSocial.Repo]}
           ] = Supervisor.which_children(pid)
  end
end
