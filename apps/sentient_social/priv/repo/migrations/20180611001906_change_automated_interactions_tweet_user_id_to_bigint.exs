defmodule SentientSocial.Repo.Migrations.ChangeAutomatedInteractionsTweetUserIdToBigint do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      modify(:tweet_user_id, :bigint)
    end
  end
end
