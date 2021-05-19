alias Chukinas.Dreadnought.{Unit, Sprite, Turret, MountRotation}
alias Chukinas.Geometry.{Pose, Rect, Position}
alias Chukinas.Util.{Maps, IdList}
# TODO do I need this dependency?
alias Chukinas.LinearAlgebra.{HasCsys, CSys, Vector}

defmodule Unit do

  # *** *******************************
  # *** TYPES

  @type damage :: {turn_number :: integer(), damage_rcvd :: integer()}

  use TypedStruct
  typedstruct enforce: true do
    field :id, integer()
    field :name, String.t()
    field :player_id, integer(), default: 1
    field :sprite, Sprite.t()
    field :turrets, [Turret.t()]
    field :pose, Pose.t()
    field :status, Unit.Status.t()
    field :events, [Unit.Event.t()], default: []
    field :past_events, [Unit.Event.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(id, opts \\ []) do
    # Refactor now that I have a unit builder module
    {max_damage, fields} =
      opts
      |> Keyword.merge(id: id)
      |> Keyword.pop!(:health)
    unit_status = Unit.Status.new(max_damage)
    fields = Keyword.merge(fields,
      status: unit_status
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** SETTERS

  def put(unit, items) when is_list(items), do: Enum.reduce(items, unit, &put(&2, &1))
  def put(unit, %Turret{} = turret), do: Maps.put_by_id(unit, :turrets, turret)
  def put(unit, event) do
    true = Unit.Event.event?(event)
    unit = Maps.push(unit, :events, event)
    case event do
      %Unit.Event.Maneuver{} -> calc_pose(unit)
      _ -> unit
    end
  end

  def clear(unit) do
    %__MODULE__{unit | events: []}
  end

  def rotate_turret(unit, mount_id, angle) do
    mount = turret(unit, mount_id)
    travel = Turret.travel_from_current_angle(mount, angle)
    put(unit, [
      # TODO validate angle?
      Turret.put_angle(mount, angle),
      Unit.Event.MountRotation.new(mount.id, angle, travel)
    ])
  end

  def apply_status(unit, function), do: Map.update!(unit, :status, function)


  # *** *******************************
  # *** GETTERS

  def maneuvers(%__MODULE__{events: events}) do
    Stream.filter(events, &is_struct(&1, Unit.Event.Maneuver))
  end

  def belongs_to?(unit, player_id), do: unit.player_id == player_id

  def gunnery_target_vector(%{pose: pose}) do
    Vector.from_position(pose)
  end
  def turret(unit, turret_id) do
    IdList.fetch!(unit.turrets, turret_id)
  end

  def all_turret_mount_ids(%__MODULE__{turrets: turrets}) do
    Enum.map(turrets, & &1.id)
  end

  def center_of_mass(%__MODULE__{sprite: sprite}) do
    sprite
    |> Sprite.rect
    |> Rect.center_position
  end

  def status(%__MODULE__{status: status}), do: status

  def pose(%__MODULE__{pose: pose}), do: pose

  def position(unit) do
    unit
    |> pose
    |> Position.new
  end


  # *** *******************************
  # *** TRANSFORMS

  def calc_pose(unit) do
    pose =
      unit
      |> maneuvers
      |> Enum.max(Unit.Event.Maneuver)
      |> Unit.Event.Maneuver.end_pose
    %__MODULE__{unit | pose: pose}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do

    def get_csys(%{pose: pose}) do
      CSys.new(pose)
    end

    def get_angle(%{pose: pose}), do: Pose.angle(pose)
  end

  defimpl Inspect do
    require IOP
    def inspect(unit, opts) do
      title = "Unit-#{unit.id}"
      fields =
        unit
        |> Map.take([
          :events
        ])
        |> Enum.into([])
      IOP.struct(title, fields)
    end
  end

end
