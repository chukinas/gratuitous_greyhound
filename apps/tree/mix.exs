defmodule Tree.MixProject do
  use Mix.Project

  def project do
    [
      app: :tree,
      version: "0.0.1",
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:dialyxir, "~>1.1", only: [:dev], runtime: false},
      {:stream_data, "~>0.5", only: [:dev, :test]},
      {:util, in_umbrella: true},
      {:typed_struct, "~> 0.2.1"}
    ]
  end
end