defmodule SentientSocial.ReleaseTasks do
  @moduledoc """
  Run migrations/seeds in a post_start hook
  """

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  alias Ecto.Migrator

  @spec sentient_social() :: atom
  def sentient_social, do: :sentient_social

  @spec repos() :: Application.value()
  def repos, do: Application.get_env(sentient_social(), :ecto_repos, [])

  @spec seed() :: atom
  def seed do
    me = sentient_social()

    IO.puts("Loading #{me}..")
    # Load the code for sentient_social, but don't start it
    :ok = Application.load(me)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for sentient_social
    IO.puts("Starting repos..")
    Enum.each(repos(), & &1.start_link(pool_size: 1))

    # Run migrations
    migrate()

    # Run seed script
    Enum.each(repos(), &run_seeds_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  @spec migrate() :: :ok
  def migrate, do: Enum.each(repos(), &run_migrations_for/1)

  @spec priv_dir(atom) :: String.t()
  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  @spec run_seeds_for(atom) :: nil
  def run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = seeds_path(repo)

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  @spec migrations_path(atom) :: String.t()
  def migrations_path(repo), do: priv_path_for(repo, "migrations")

  @spec seeds_path(atom) :: String.t()
  def seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

  @spec priv_path_for(atom, String.t()) :: String.t()
  def priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
