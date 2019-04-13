defmodule SentientSocial.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :provider, :string
      add :token, :binary
      add :token_secret, :binary
      add :user_id, references(:users, on_delete: :delete_all, null: false)

      timestamps()
    end

    create index(:tokens, [:user_id])
  end
end
