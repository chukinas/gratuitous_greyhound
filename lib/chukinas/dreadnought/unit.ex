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
    field :player_id, integer(), default: 1
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
    %{unit | cmd_squares: cmd_squares}
  end

  # *** *******************************
  # *** COMMANDS

  def resolve_command(unit, command) do
    move_to(unit, command.move_to)
  end

  # *** *******************************
  # *** BOOLEANS

  def belongs_to?(unit, player_id), do: unit.player_id == player_id

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
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(unit, opts) do
      unit_map = unit |> Map.take([:id, :pose, :maneuver_svg_string, :player_id])
      concat ["#Unit<", to_doc(unit_map, opts), ">"]
    end
  end
end
