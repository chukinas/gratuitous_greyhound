alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet}
alias Chukinas.Geometry.{Pose, Position, Turn, Straight, Polygon, Path}
alias Chukinas.Svg

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    # ID must be unique within the world
    field :id, integer()
    field :pose, Pose.t()
    field :maneuver_svg_string, String.t()
    field :sprite, Sprite.t(), default: Spritesheet.red("ship_large")
  end

  # *** *******************************
  # *** NEW

  def new(id, opts \\ []) do
    struct(__MODULE__, Keyword.put(opts, :id, id))
  end

  # *** *******************************
  # *** API

  def move_along_path(unit, path) do
    %{unit |
      pose: Path.get_end_pose(path),
      maneuver_svg_string: Svg.get_path_string(path)
    }
  end

  def get_motion_range(%__MODULE__{pose: pose}, trim_angle \\ 0) do
    max_distance = 400
    min_distance = 200
    angle = 45
    [
      Straight.new(pose, min_distance),
      Turn.new(pose, min_distance, trim_angle - angle),
      Turn.new(pose, max_distance, trim_angle - angle),
      Straight.new(pose, max_distance),
      Turn.new(pose, max_distance, trim_angle + angle),
      Turn.new(pose, min_distance, trim_angle + angle),
    ]
    |> Stream.map(&Path.get_end_pose/1)
    |> Enum.map(&Position.to_tuple/1)
    |> Polygon.new
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  #defimpl Inspect do
  #  import Inspect.Algebra
  #  def inspect(unit, opts) do
  #    unit_map = unit |> Map.take([:id, :pose, :maneuver_svg_string])
  #    concat ["#Unit<", to_doc(unit_map, opts), ">"]
  #  end
  #end
end
