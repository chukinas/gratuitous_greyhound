alias Chukinas.Dreadnought.{PathPartial}
alias Chukinas.Geometry.Path
alias Chukinas.Svg

# TODO rename ManeuverPartial
# TODO from now on, draw a distinction b/w path (pure geometry) and maneuver (the course a unit cuts thru the sea)
defmodule PathPartial do
  @moduledoc """
  Fully qualifies a portion of a unit's path

  A list of these (or even none or just one) is used by the frontend
  to render a series of motion animations.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :geo_path, Path.t()
    field :svg_path, String.t()
    field :fractional_start_time, number()
    field :fractional_duration, number()
  end

  def new(geo_path, opts \\ []) do
    fields = Chukinas.Util.Opts.merge!(opts,
      fractional_start_time: 0,
      fractional_duration: 1
    )
    |> Keyword.merge(
      geo_path: geo_path,
      svg_path: Svg.get_path_string(geo_path)
    )
    struct!(__MODULE__, fields)
  end

  def end_pose(%{geo_path: path}) do
    Path.get_end_pose(path)
  end

  def compare(%{fractional_start_time: a}, %{fractional_start_time: b}) do
    cond do
      a < b -> :lt
      a > b -> :gt
      a == b -> :eq
    end
  end

  # TODO delete or make part of Maneuver module
  def new_list(geo_path), do: [new(geo_path)]
end
