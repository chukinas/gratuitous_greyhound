defmodule Dreadnought.Core.Unit do

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
    use Dreadnought.Sprite.Spec
    use Spatial.TypedStruct
  alias Dreadnought.Core.Turret
  alias Dreadnought.Core.Unit.Event, as: Ev
  alias Dreadnought.Core.Unit.Status
  alias Spatial.Geometry.Rect
  alias Dreadnought.Sprite
  alias Util.IdList
  alias Util.Maps

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    pose_fields()
    field :id, integer()
    field :name, String.t(), enforce: false
    field :player_id, integer
    field :sprite_spec, sprite_spec
    field :turrets, [Turret.t()]
    field :health, integer()
    field :status, Status.t()
    field :events, [Ev.t()], default: []
    field :past_events, [Ev.t()], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(integer, integer, any, keyword) :: t
  def new(id, player_id, sprite_spec, pose, opts \\ []) do
    # Refactor now that I have a unit builder module
    {max_damage, fields} =
      opts
      |> Keyword.merge(id: id)
      |> Keyword.pop!(:health)
    unit_status = Status.new()
    fields =
      Keyword.merge(fields,
        player_id: player_id,
        status: unit_status,
        health: max_damage,
        sprite_spec: sprite_spec
      )
      |> Map.new
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** REDUCERS

  def push_past_events(unit, events) do
    Maps.push(unit, :past_events, events)
  end

  def put(unit, items) when is_list(items), do: Enum.reduce(items, unit, &put(&2, &1))
  def put(unit, %Turret{} = turret), do: Maps.put_by_id(unit, :turrets, turret)
  def put(unit, %Status{} = status) do
    %__MODULE__{unit | status: status}
  end
  def put(unit, event) do
    true = Ev.event?(event)
    unit = Maps.push(unit, :events, event)
    case event do
      %Ev.Maneuver{} -> calc_pose(unit)
      _ -> unit
    end
  end

  def rotate_turret(unit, mount_id, angle) do
    mount = turret(unit, mount_id)
    travel = Turret.travel_from_current_angle(mount, angle)
    put(unit, [
      angle_replace!(mount, angle),
      Ev.MountRotation.new(mount.id, angle, travel)
    ])
  end

  def apply_status(unit, function), do: Map.update!(unit, :status, function)

  def calc_pose(unit) do
    unit
    |> maneuvers
    |> Enum.max(Ev.Maneuver)
    |> Ev.Maneuver.end_pose
    |> merge_pose_into!(unit)
  end

  def clear(unit) do
    # TODO rename reset_for_new_turn or something like that
    new_past_events =
      unit
      |> stashable_events
      |> Enum.to_list
    unit
    |> push_past_events(new_past_events)
    |> Map.put(:events, [])
  end

  def maybe_destroyed(unit) do
    alias Ev.Damage
    alias Ev.Damage.Enum, as: Damages
    damages = damage(unit)
    starting_health = starting_health(unit)
    still_alive? =
      damages
      |> Damages.has_remaining_health?(starting_health)
    if still_alive? do
      unit
    else
      {turn, delay} =
        damages
        |> Stream.map(&Damage.turn_and_delay/1)
        |> Enum.max
      destruction = Ev.Destroyed.by_gunfire(turn, delay + 0.2)
      fadeout = Ev.Destroyed.get_fadeout(destruction)
      put(unit, [destruction, fadeout])
    end
  end

  def position_mass_center(%__MODULE__{} = unit, position \\ position_null())
  when has_position(position) do
    translate =
      unit
      # TODO rename position_of_mass_center
      |> center_of_mass
    position_subtract(unit, translate)
  end

  # *** *******************************
  # *** CONVERTERS

  def angle(%__MODULE__{angle: value}), do: value

  def find_event(unit, event_module, which \\ :all) do
    unit
    |> events(which)
    |> Enum.find(&is_struct(&1, event_module))
  end

  def filter_events(unit, event_module, which \\ :all) do
    unit
    |> events(which)
    |> Enum.filter(&is_struct(&1, event_module))
  end

  def id(%__MODULE__{id: value}), do: value

  def length(_unit) do
    # TODO placeholder
    200
  end

  def any_events?(unit, event_module, which \\ :all) do
    unit
    |> events(which)
    |> Enum.any?(&is_struct(&1, event_module))
  end

  def events(unit, which \\ :all)
  def events(%__MODULE__{events: value}, :current), do: value
  def events(%__MODULE__{past_events: value}, :past), do: value
  def events(%__MODULE__{events: current, past_events: past}, :all) do
    Stream.concat(current, past)
  end

  def render?(%__MODULE__{status: status}) do
    status.render?
  end

  def starting_health(%__MODULE__{health: value}), do: value

  def percent_health(unit) do
    starting_health(unit) / Ev.Damage.Enum.remaining_health(
      damage(unit),
      starting_health(unit)
    )
  end

  def stashable_events(%__MODULE__{events: events}) do
    Enum.filter(events, &Ev.stashable?/1)
  end

  def damage(unit), do: filter_events(unit, Ev.Damage)

  def maneuvers(unit), do: filter_events(unit, Ev.Maneuver)

  def belongs_to?(unit, player_id), do: unit.player_id == player_id

  def gunnery_target_vector(unit) do
    unit
    |> position
    |> vector_from_position
  end

  @spec turret(t, integer) :: Turret.t
  def turret(unit, turret_id) do
    IdList.fetch!(unit.turrets, turret_id)
  end

  def turret_random(unit) do
    mount_id =
      unit
      |> all_turret_mount_ids
      |> Enum.random
    turret(unit, mount_id)
  end

  def all_turret_mount_ids(%__MODULE__{turrets: turrets}) do
    Enum.map(turrets, & &1.id)
  end

  def center_of_mass(%__MODULE__{sprite_spec: sprite_spec}) do
    sprite_spec
    |> Sprite.Builder.build
    |> Rect.center_position
  end

  def status(%__MODULE__{status: status}), do: status

  def width(%__MODULE__{sprite_spec: sprite_spec}) do
    sprite_spec
    |> Sprite.Builder.build
    |> height
  end

  def world_coord_random_in_arc(%__MODULE__{} = unit, distance) do
    turret = turret_random unit
    angle = Turret.angle_random_in_arc turret
    target_coord_wrt_turret_loc = vector_from_polar(distance, angle)
    vector_wrt_outer_observer(target_coord_wrt_turret_loc, [turret |> position_new, unit])
  end

end

# *** *********************************
# *** IMPLEMENTATIONS
# *** *********************************

alias Dreadnought.Core.Unit

defimpl Inspect, for: Unit do
  require IOP
  def inspect(unit, opts) do
    title = "Unit-#{unit.id}"
    fields =
      unit
      |> Map.take([
        :events,
        :past_events
      ])
      |> Enum.into([])
      |> Keyword.merge(
        health: unit.health
        #percent_health: Unit.percent_health(unit)
      )
    IOP.struct(title, fields)
  end
end

defimpl Spatial.LinearAlgebra.HasCsys, for: Unit do

  use Spatial.LinearAlgebra

  def get_csys(unit) do
    csys_from_pose unit
  end

  # TODO rename `angle`
  def get_angle(unit), do: Dreadnought.Core.Unit.angle(unit)
end
