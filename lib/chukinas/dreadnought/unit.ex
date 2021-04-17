alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret}
alias Chukinas.Geometry.{Pose, Position, Turn, Straight, Polygon, Path, Grid, GridSquare, Collide}
alias Chukinas.Svg

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # ID must be unique within the world
    field :id, integer()
    field :pose, Pose.t()
    field :cmd_squares, [GridSquare.t()], default: []
    # TODO rename path?
    field :maneuver_svg_string, String.t(), enforce: false
    field :sprite, Sprite.t()
    field :turrets, [Turret.t()]
  end

  # *** *******************************
  # *** NEW

  def new(id, opts \\ []) do
    sprite = Spritesheet.red("ship_large")
    turrets =
      [
        {1, 0},
        {2, 180}
      ]
      |> Enum.map(fn {id, angle} ->
        # TODO I don't think I need a mounting struct.
        # Just replace the list of structs with a single map of positions.
        # I'll wait to do this though until I convince myself
        # that I don't need a struct with any other props.
        position =
          sprite.mountings
          |> Enum.find(&(&1.id == id))
          |> Map.fetch!(:position)
          |> Pose.new(angle)
        Turret.new(id, position, Spritesheet.red("turret1"))
      end)
      |> IOP.inspect
    opts =
      opts
      |> Keyword.put_new(:sprite, sprite)
      |> Keyword.put_new(:turrets, turrets)
      |> Keyword.put(:id, id)
    struct!(__MODULE__, opts)
  end

  # *** *******************************
  # *** COMMANDS

  def resolve_command(unit, command) do
    move_to(unit, command.move_to)
  end

  # *** *******************************
  # *** MANEUVER EXECUTION

  def move_to(unit, position) do
    path = Path.get_connecting_path(unit.pose, position)
    %{unit |
      pose: Path.get_end_pose(path),
      maneuver_svg_string: Svg.get_path_string(path)
    }
  end

  # *** *******************************
  # *** MANEUVER PLANNING

  def calc_cmd_squares(unit, grid, islands) do
    # TODO 185 work trim back into the calc
    cmd_zone = get_motion_range(unit)
    cmd_squares =
      grid
      |> Grid.squares(include: cmd_zone, exclude: islands)
      |> Stream.map(&GridSquare.calc_path(&1, unit.pose))
      |> Stream.filter(&Collide.avoids?(&1.path, islands))
      |> Enum.to_list
    %{unit | cmd_squares: cmd_squares}
  end

  defp get_motion_range(%__MODULE__{pose: pose}, trim_angle \\ 0) do
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

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(unit, opts) do
      unit_map = unit |> Map.take([:id, :pose, :maneuver_svg_string])
      concat ["#Unit<", to_doc(unit_map, opts), ">"]
    end
  end
end
