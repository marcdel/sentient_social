defmodule SentientSocial.Repo.Migrations.AddTwitterFollowersToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:twitter_followers_count, :integer)
    end
  end
end
