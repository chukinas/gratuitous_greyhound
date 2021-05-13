alias Chukinas.Dreadnought.{Unit, Sprite, Turret, ManeuverPartial, Maneuver, MountRotation}
alias Chukinas.Geometry.{Pose, Path, Rect}
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
    # Varies from game turn to game turn
    field :pose, Pose.t()
    # TODO should this be handled in .clear()?
    field :compound_path, Maneuver.t(), default: []
    field :status, Unit.Status.t()
  end

  # *** *******************************
  # *** NEW

  # Refactor now that I have a unit builder module
  def new(id, opts \\ []) do
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
  def put(unit, %MountRotation{} = mount_action), do: Maps.put_by_id(unit, :mount_actions, mount_action, :mount_id)

  # TODO delete
  def put_path(%__MODULE__{} = unit, geo_path) do
    %{unit |
      pose: Path.get_end_pose(geo_path),
      compound_path: [ManeuverPartial.new(geo_path)]
    }
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
  end

  def clear(unit) do
    %__MODULE__{unit | mount_actions: []}
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

  def apply_status(unit, function), do: Map.update!(unit, :status, function)

  # *** *******************************
  # *** GETTERS

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

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do
    def get_csys(%{pose: pose}) do
      CSys.new(pose)
    end
    def get_angle(%{pose: pose}), do: Pose.angle(pose)
  end

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(unit, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      unit_map =
        unit
        |> Map.take([
          :status,
          :selection_box_position
        ])
        |> Enum.into([])
        #|> Keyword.put(:health, Unit.percent_remaining_health(unit))
      concat [
        col.("#Unit-#{unit.id}<"),
        to_doc(unit_map, opts),
        col.(">")
      ]
    end
  end
end
