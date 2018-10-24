defmodule SentientSocialWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sentient_social_web,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SentientSocialWeb.Application, []},
      extra_applications: [:logger, :runtime_tools, :sentry, :timber]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:sentient_social, in_umbrella: true},
      {:cowboy, "~> 1.0"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:excoveralls, "~> 0.8", only: :test},
      {:ueberauth_twitter, github: "ueberauth/ueberauth_twitter"},
      {:oauth, github: "tim/erlang-oauth"},
      {:phoenix_integration, "~> 0.5", only: :test},
      {:sentry, "~> 6.2.1"},
      {:timber, "~> 2.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
