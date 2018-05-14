defmodule SentientSocial.Repo.Migrations.CreateHistoricalFollowerCounts do
  use Ecto.Migration

  def change do
    create table(:historical_follower_counts) do
      add :count, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:historical_follower_counts, [:user_id])
  end
end
