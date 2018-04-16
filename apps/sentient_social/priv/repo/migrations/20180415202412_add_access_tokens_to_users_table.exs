defmodule SentientSocial.Repo.Migrations.AddAccessTokensToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:access_token, :binary)
      add(:access_token_secret, :binary)
    end
  end
end
