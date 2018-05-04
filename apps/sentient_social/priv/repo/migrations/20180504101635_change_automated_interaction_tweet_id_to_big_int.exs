defmodule SentientSocial.Repo.Migrations.ChangeAutomatedInteractionTweetIdToBigInt do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      modify(:tweet_id, :bigint)
    end
  end
end
