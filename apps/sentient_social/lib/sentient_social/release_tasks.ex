defmodule SentientSocial.ReleaseTasks do
  @moduledoc """
  Run migrations in a post_start hook
  """

  alias Ecto.Migrator

  @spec migrate() :: [integer]
  def migrate do
    {:ok, _} = Application.ensure_all_started(:sentient_social)

    path = Application.app_dir(:sentient_social, "priv/repo/migrations")

    Migrator.run(SentientSocial.Repo, path, :up, all: true)
  end
end
