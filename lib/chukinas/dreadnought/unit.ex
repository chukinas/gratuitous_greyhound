alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret, ManeuverPartial, Maneuver, MountRotation}
alias Chukinas.Geometry.{Pose, Path, Position}
alias Chukinas.Util.{Maps, IdList}
# TODO do I need this dependency?
alias Chukinas.LinearAlgebra.{HasCsys, CSys, Vector}

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

  # *** *******************************
  # *** TYPES

  @type damage :: {integer(), integer()} # turn & damage rcv'ed that turn

  use TypedStruct
  typedstruct enforce: true do
    field :id, integer()
    field :name, String.t()
    field :player_id, integer(), default: 1
    field :sprite, Sprite.t()
    # TODO rename mounts
    # TODO should include anything that's positioned relative to the hull
    field :turrets, [Turret.t()]
    field :mount_actions, [MountRotation.t()], default: []
    # TODO this is not correct. Should just be an integer?
    field :health, damage()
    # Varies from game turn to game turn
    field :pose, Pose.t()
    field :selection_box_position, Position.t(), enforce: false
    # TODO should this be handled in .clear()?
    field :compound_path, Maneuver.t(), default: []
    # TODO rename :turn_destroyed
    field :final_turn, integer(), enforce: false
    # Accumulated State
    # TODO add type
    field :damage, [damage()], default: []
    # calculated values for frontend
    field :render?, boolean(), default: true
    field :active?, boolean(), default: true
  end

  # *** *******************************
  # *** NEW

  # Refactor now that I have a unit builder module
  def new(id, opts \\ []) do
    sprite = Spritesheet.red("ship_large")
    opts =
      [
        health: 100,
        sprite: sprite,
      ]
      |> Keyword.merge(opts)
      |> Keyword.merge(id: id)
    struct!(__MODULE__, opts)
    |> calc_selection_box_position
  end

  # *** *******************************
  # *** SETTERS

  def put(unit, items) when is_list(items), do: Enum.reduce(items, unit, &put(&2, &1))
  def put(unit, %Turret{} = turret), do: Maps.put_by_id(unit, :turrets, turret)
  def put(unit, %MountRotation{} = mount_action), do: Maps.put_by_id(unit, :mount_actions, mount_action, :mount_id)

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

  def put_damage(unit, damage, turn_number), do: Maps.push(unit, :damage, {turn_number, damage})

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

  def clear(unit) do
    %__MODULE__{unit | mount_actions: []}
  end

  def calc_random_mount_orientation(unit) do
    Enum.reduce(unit.turrets, unit, fn mount, unit ->
      {_, corrected_angle} = Turret.normalize_desired_angle(
        mount,
        Enum.random(0..359))
      rotate_turret(unit, mount.id, corrected_angle)
    end)
  end

  def rotate_turret(unit, mount_id, angle) do
    mount = turret(unit, mount_id)
    travel = Turret.travel_from_current_angle(mount, angle)
    put(unit, [
      # TODO validate angle?
      Turret.put_angle(mount, angle),
      MountRotation.new(mount.id, angle, travel)
    ])
  end

  # *** *******************************
  # *** GETTERS

  def belongs_to?(unit, player_id), do: unit.player_id == player_id
  def total_damage(%{damage: damages}) do
    damages
    |> Stream.map(fn {_turn, damage} -> damage end)
    |> Enum.sum
  end
  def remaining_health(%{health: health} = unit) do
    (health - total_damage(unit))
    |> max(0)
  end
  def percent_remaining_health(%{health: health} = unit) do
    (1 - total_damage(unit) / health)
    |> max(0)
  end
  def gunnery_target_vector(%{pose: pose}) do
    Vector.from_position(pose)
  end
  def turret(unit, turret_id) do
    IdList.fetch!(unit.turrets, turret_id)
  end
  def all_turret_mount_ids(%__MODULE__{turrets: turrets}) do
    Enum.map(turrets, & &1.id)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(unit, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      unit_map =
        unit
        |> Map.take([
          :pose,
          :turrets,
          :mount_actions
        ])
        |> Enum.into([])
        #|> Keyword.put(:health, Unit.percent_remaining_health(unit))
      concat [
        col.("#Unit-#{unit.id}"),
        to_doc(unit_map, opts)]
    end
  end

  defimpl HasCsys do
    def get_csys(%{pose: pose}) do
      CSys.new(pose)
    end
    def get_angle(%{pose: pose}), do: Pose.angle(pose)
  end
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
