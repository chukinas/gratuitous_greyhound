defmodule Statechart.MixProject do
  use Mix.Project

  def project do
    [
      app: :statechart,
      version: "0.2.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  #defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:dialyxir, "~>1.1", only: [:dev], runtime: false},
      {:json, "~>1.4"},
      {:util, in_umbrella: true},
      {:typed_struct, "~> 0.2.1"}
    ]
  end
end
