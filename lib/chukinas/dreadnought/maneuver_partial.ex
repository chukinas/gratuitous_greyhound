alias Chukinas.Dreadnought.{ManeuverPartial}
alias Chukinas.Geometry.Path
alias Chukinas.Svg

defmodule ManeuverPartial do
  @moduledoc """
  Fully qualifies a portion of a unit's maneuver

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

  # *** *******************************
  # *** NEW

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

  # *** *******************************
  # *** GETTERS

  def end_pose(%{geo_path: path}) do
    Path.get_end_pose(path)
  end

  # *** *******************************
  # *** STRUCT COMPARE

  def compare(%{fractional_start_time: a}, %{fractional_start_time: b}) do
    cond do
      a < b -> :lt
      a > b -> :gt
      a == b -> :eq
    end
  end
end
