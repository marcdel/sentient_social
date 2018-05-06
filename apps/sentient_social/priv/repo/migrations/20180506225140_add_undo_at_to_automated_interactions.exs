defmodule SentientSocial.Repo.Migrations.AddUndoAtToAutomatedInteractions do
  use Ecto.Migration

  def change do
    alter table(:automated_interactions) do
      add(:undo_at, :date)
    end
  end
end
