defmodule SentientSocial.Repo.Migrations.RemoveUsernameFromUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :username, :string
    end

    alter table(:tokens) do
      add :username, :string
    end
  end
end
