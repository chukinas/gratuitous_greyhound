defmodule Spatial.MixProject do
  use Mix.Project

  def project do
    [
      app: :spatial,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:util, in_umbrella: true},
      {:collision, "~> 0.3.1"},
      {:typed_struct, "~> 0.2.1"}
    ]
  end
end
