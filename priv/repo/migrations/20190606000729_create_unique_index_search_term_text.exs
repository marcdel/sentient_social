defmodule SentientSocial.Repo.Migrations.CreateUniqueIndexSearchTermText do
  use Ecto.Migration

  def change do
    create unique_index(:search_terms, [:text])
  end
end
