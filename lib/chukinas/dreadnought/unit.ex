alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret, UnitManeuverPath}
alias Chukinas.Geometry.{Pose, Path, GridSquare, Straight, Turn, Polygon, Position}
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
    field :player_id, integer(), default: 1
    field :sprite, Sprite.t()
    field :turrets, [Turret.t()]
    # Varies from game turn to game turn
    field :pose, Pose.t()
    field :path, Path.t(), enforce: false
    field :cmd_squares, [GridSquare.t()], default: []
    field :maneuver_paths, [UnitManeuverPath.t()], default: []
    field :exiting?, boolean(), default: false
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
          sprite.mounts[id]
          |> Pose.new(angle)
        Turret.new(id, position, Spritesheet.red("turret1") |> Sprite.center)
      end)
    opts =
      opts
      |> Keyword.put_new(:sprite, sprite |> Sprite.center)
      |> Keyword.put_new(:turrets, turrets)
      |> Keyword.put(:id, id)
    struct!(__MODULE__, opts)
  end

  # *** *******************************
  # *** SETTERS

  def put_cmd_squares(unit, cmd_squares) do
    %{unit | cmd_squares: cmd_squares |> Enum.to_list}
  end
  def put_path(unit, path) do
    %{unit |
      pose: Path.get_end_pose(path),
      path: path,
      maneuver_paths: UnitManeuverPath.new_list(Svg.get_path_string(path))
    }
  end

  # *** *******************************
  # *** COMMANDS

  def resolve_command(_unit, :exit_or_run_aground) do
    raise "Implement this!"
  end
  def resolve_command(unit, {:move_to, position}) do
    move_to(unit, position)
  end

  # *** *******************************
  # *** BOOLEANS

  def belongs_to?(unit, player_id), do: unit.player_id == player_id
  def no_cmd_squares?(unit), do: Enum.empty?(unit.cmd_squares)

  # *** *******************************
  # *** MANEUVER

  def move_to(unit, position) do
    path = Path.get_connecting_path(unit.pose, position)
    put_path(unit, path)
  end

  def exit_or_run_aground(unit) do
    path = Path.put_pose(unit.path, unit.pose)
    put_path(unit, path)
    |> Map.put(:exiting?, true)
  end

  def get_maneuver_polygon(%__MODULE__{pose: pose}, trim_angle \\ 0) do
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
      unit_map = unit |> Map.take([:id, :pose, :maneuver_svg_string, :player_id])
      concat ["#Unit<", to_doc(unit_map, opts), ">"]
    end
  end
end
