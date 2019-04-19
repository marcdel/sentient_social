defmodule SentientSocial.Repo.Migrations.CreateSearchTerms do
  use Ecto.Migration

  def change do
    create table(:search_terms) do
      add :text, :text
      add :user_id, references(:users, on_delete: :delete_all, null: false)

      timestamps()
    end

    create index(:search_terms, [:user_id])
  end
end
