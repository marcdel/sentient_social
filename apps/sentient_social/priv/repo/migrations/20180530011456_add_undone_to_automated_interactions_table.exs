defmodule SentientSocial.Repo.Migrations.AddUndoneToAutomatedInteractionsTable do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      add(:undone, :boolean, null: false, default: false)
    end
  end
end
