defmodule SentientSocial.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :name, :string
      add :profile_image_url, :string

      timestamps()
    end

  end
end
