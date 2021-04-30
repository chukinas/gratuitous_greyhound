alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret, PathPartial}
alias Chukinas.Geometry.{Pose, Path}

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
    field :compound_path, [PathPartial.t()], default: []
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

  # TODO delete
  def put_path(%__MODULE__{} = unit, geo_path) do
    %{unit |
      pose: Path.get_end_pose(geo_path),
      compound_path: PathPartial.new_list(geo_path)
    }
  end

  # TODO rename put_maneuver
  def put_compound_path(unit, compound_path) when is_list(compound_path) do
    pose =
      compound_path
      |> Enum.max(PathPartial)
      |> PathPartial.end_pose
    %__MODULE__{unit |
      pose: pose,
      # TODO rename maneuver
      compound_path: compound_path
    }
  end

  # *** *******************************
  # *** GETTERS

  def belongs_to?(unit, player_id), do: unit.player_id == player_id

  # *** *******************************
  # *** IMPLEMENTATIONS

  #defimpl Inspect do
  #  import Inspect.Algebra
  #  def inspect(unit, opts) do
  #    unit_map = unit |> Map.take([:id, :pose, :maneuver_svg_string, :player_id])
  #    concat ["#Unit<", to_doc(unit_map, opts), ">"]
  #  end
  #end
end
