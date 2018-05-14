defmodule SentientSocial.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 1.0.0"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:inch_ex, "~> 0.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end
end
