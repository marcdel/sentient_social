defmodule SentientSocial.Accounts do
  alias SentientSocial.Accounts.User

  def list_users do
    [
      %User{id: "1", name: "Marc", username: "marcdel"},
      %User{id: "2", name: "Jackie", username: "jackie"}
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn user -> user.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn user ->
      Enum.all?(params, fn {key, val} -> Map.get(user, key) == val end)
    end)
  end
end
