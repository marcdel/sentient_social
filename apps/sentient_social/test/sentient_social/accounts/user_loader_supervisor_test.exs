defmodule UserLoaderSupervisorTest do
  use SentientSocial.DataCase, async: true

  alias SentientSocial.Accounts.{UserLoaderSupervisor, UserSupervisor, UserLoader}

  test "starts the user supervisor and the user loader using the rest_for_one strategy" do
    assert UserLoaderSupervisor.init(:ok) ==
             {:ok,
              {%{intensity: 3, period: 5, strategy: :rest_for_one},
               [
                 %{
                   id: UserSupervisor,
                   start: {UserSupervisor, :start_link, [[]]},
                   type: :supervisor
                 },
                 {Task, {Task, :start_link, [&UserLoader.load/0]}, :temporary, 5000, :worker,
                  [Task]}
               ]}}
  end
end
