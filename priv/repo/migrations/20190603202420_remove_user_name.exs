defmodule SentientSocial.Repo.Migrations.RemoveUserName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name, :string
    end
  end
end
