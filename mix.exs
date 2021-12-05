defmodule Dreadnought.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      # ExDoc:
      name: "Gratuitous Greyhound",
      source_url: "https://github.com/jonathanchukinas/gratuitous_greyhound",
      docs: docs()
    ]
  end

  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:dialyxir, "~>1.1", only: [:dev], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"]
    ]
  end

  defp docs do
    # https://hexdocs.pm/ex_doc/readme.html
    [
      groups_for_modules: [
        "Util": [
          IOP,
          ~r/Util/
        ],
        Statechart: [~r/Statechart/],
        Spatial: [Spatial],
        "Linear Algebra": [~r/Spatial.LinearAlgebra/],
        "Collision Detection": [~r/Spatial.Collide/],
        "Position, Orientation, and Size": [~r/Spatial.PositionOrientationSize/],
        "Geometry": [~r/Spatial.Geometry/],
        "Math": [Spatial.Math],
        "Modules in Need of a Better Home": [
          ~r/Dreadnought/,
          Spatial.BoundingRect,
          Spatial.TypedStruct,
          Spatial.Vector
        ],
      ],
      logo: "docs_logo.jpg",
      formatters: ["html"],
      authors: ["Jonathan Chukinas"],
      source_ref: "master",
      #source_url_pattern: "https://github.com/jonathanchukinas/gratuitous_greyhound/blob/master/%{path}#L%{line}"
      # https://hexdocs.pm/ex_doc/Mix.Tasks.Docs.html#module-nesting
      nest_modules_by_prefix: [
        Statechart,
        Spatial,
        SunsCore,
        Util
      ],
      ignore_apps: [
        :collision_detection,
        :dreadnought,
        :dreadnought_web
      ]
    ]
  end
end
