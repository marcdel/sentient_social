defmodule SentientSocial.MixProject do
  use Mix.Project

  def project do
    [
      app: :sentient_social,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SentientSocial.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.16"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:credo, "~> 1.0"},
      {:argon2_elixir, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:pbkdf2_elixir, "~> 1.0"},
      {:cloak, "~> 0.9"},
      {:phoenix_integration, "~> 0.6", only: :test},
      {:ueberauth_twitter, "~> 0.3"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.9"},
      {:mox, "~> 0.5", only: :test},
      {:timber, "~> 3.1"},
      {:timber_phoenix, "~> 1.0"},
      {:timber_ecto, "~> 2.0"},
      {:timber_exceptions, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
