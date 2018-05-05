defmodule SentientSocial.Repo.Migrations.AddTweetUrlToAutomatedInteraction do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      add(:tweet_url, :string)
    end
  end
end
