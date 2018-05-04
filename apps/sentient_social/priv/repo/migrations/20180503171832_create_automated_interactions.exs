defmodule SentientSocial.Repo.Migrations.CreateAutomatedInteractions do
  use Ecto.Migration

  def change do
    create table(:automated_interactions) do
      add(:tweet_id, :integer)
      add(:tweet_text, :string)
      add(:tweet_user_handle, :string)
      add(:tweet_user_description, :string)
      add(:interaction_type, :string)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:automated_interactions, [:user_id]))
    create(unique_index(:automated_interactions, [:user_id, :tweet_id, :interaction_type]))
  end
end
