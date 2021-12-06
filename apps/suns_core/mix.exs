defmodule SunsCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :suns_core,
      version: "0.1.0",
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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto]
    ]
  end

  defp elixirc_paths(env) when env in ~w/dev test/a, do: ~w(lib test/support)
  defp elixirc_paths(_), do: ~w/lib/

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:collision_detection, in_umbrella: true},
      {:spatial, in_umbrella: true},
      {:statechart, in_umbrella: true},
      {:util, in_umbrella: true},
      {:typed_struct, "~> 0.2.1"}
    ]
  end
end
