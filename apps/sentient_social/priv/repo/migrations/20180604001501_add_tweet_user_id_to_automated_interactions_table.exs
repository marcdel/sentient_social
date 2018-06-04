defmodule SentientSocial.Repo.Migrations.AddTweetUserIdToAutomatedInteractionsTable do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      add(:tweet_user_id, :integer)
    end
  end
end
