alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret, ManeuverPartial, Maneuver}
alias Chukinas.Geometry.{Pose, Path, Position}

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :name, String.t()
    field :player_id, integer(), default: 1
    field :sprite, Sprite.t()
    field :turrets, [Turret.t()]
    # Varies from game turn to game turn
    field :pose, Pose.t()
    field :selection_box_position, Position.t(), enforce: false
    field :compound_path, Maneuver.t(), default: []
    # TODO rename :turn_destroyed
    field :final_turn, integer(), enforce: false
    # calculated values for frontend
    field :render?, boolean(), default: true
    field :active?, boolean(), default: true
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
    |> calc_selection_box_position
  end

  # *** *******************************
  # *** SETTERS

  # TODO delete
  def put_path(%__MODULE__{} = unit, geo_path) do
    %{unit |
      pose: Path.get_end_pose(geo_path),
      compound_path: [ManeuverPartial.new(geo_path)]
    }
    |> calc_selection_box_position
  end

  # TODO rename put_maneuver
  def put_compound_path(unit, compound_path) when is_list(compound_path) do
    pose =
      compound_path
      |> Enum.max(ManeuverPartial)
      |> ManeuverPartial.end_pose
    %__MODULE__{unit |
      pose: pose,
      # TODO rename maneuver
      compound_path: compound_path
    }
    |> calc_selection_box_position
  end

  def put_final_turn(unit, final_turn) do
    %__MODULE__{unit | final_turn: final_turn}
  end

  # TODO This 50 is just a guess. Need actual logic here.
  def calc_selection_box_position(unit) do
    position =
      unit.pose
      |> Pose.straight(-20)
      |> Position.new
    %__MODULE__{unit | selection_box_position: position}
  end

  def calc_active(unit, turn_number) do
    %__MODULE__{unit | active?: case unit.final_turn do
      nil -> true
      turn when turn_number >= turn -> false
      _ -> true
    end}
  end

  def calc_render(unit, turn_number) do
    %__MODULE__{unit | render?: case unit.final_turn do
      nil -> true
      turn when turn_number > turn -> false
      _ -> true
    end}
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

defmodule Unit.Enum do
  # TODO rename player_active_unit_ids
  def active_player_unit_ids(units, player_id) do
    units
    |> Stream.filter(& &1.active?)
    |> Stream.filter(&Unit.belongs_to?(&1, player_id))
    |> Enum.map(& &1.id)
  end
  # TODO rename enemy_active_unit_ids
  def enemy_unit_ids(units, player_id) do
    units
    |> Stream.filter(& &1.active?)
    |> Stream.filter(& !Unit.belongs_to?(&1, player_id))
    |> Enum.map(& &1.id)
  end
end
