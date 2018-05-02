defmodule SentientSocial.Repo.Migrations.AddMutedFlagToKeywords do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      add(:muted, :boolean, default: false, null: false)
    end
  end
end
