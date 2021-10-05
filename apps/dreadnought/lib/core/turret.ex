defmodule Dreadnought.Core.Turret do
  @moduledoc"""
  Represents a rotating weapon on a unit

  Definitions:
  max_ccw_angle - the angle, measured wrt unit's bow, parallel with maximum CCW rotation
  rotation - the turret's orientation, measured wrt turret's max_ccw_angle, b/w 0 and 360
  rest_angle - turret orientation at rest, measured wrt unit's bow
  travel - how far, cw or ccw, the turret must turn from its current orientation to face a new one
  arc - the 2D cone between the max ccw and max cw angles. Fixed to unit.
  """

    use Spatial.LinearAlgebra
    use Spatial.Math
    use Spatial.PositionOrientationSize
    use Spatial.TypedStruct
  # TODO replace with use of LinearAlgebra?
  alias Spatial.LinearAlgebra.HasCsys
  alias Spatial.LinearAlgebra.Vector
  # TODO needed with the use above?
  alias Spatial.Math
  alias Dreadnought.Sprite

  # *** *******************************
  # *** TYPES

  @max_rotation 270

  typedstruct enforce: true do
    field :id, integer()
    field :sprite, Sprite.t
    field :max_ccw_angle, degrees :: number()
    field :max_rotation, positive_degrees :: number()
    field :rest_angle, degrees :: number()
    pose_fields()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(id, sprite, pose) do
    rest_angle =
      pose
      |> angle_normalize
      |> angle
    fields =
      %{
        id: id,
        sprite: sprite,
        max_ccw_angle: normalize_angle(rest_angle - @max_rotation / 2),
        max_rotation: @max_rotation,
        rest_angle: rest_angle,
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** CONVERTERS

  def angle_at_half_rotation(%__MODULE__{} = turret) do
    rotation = rotation_half_max(turret)
    angle_for_given_rotation(turret, rotation)
  end

  def angle_for_given_rotation(%__MODULE__{max_rotation: max_rotation} = turret, rotation) when rotation >= 0 and rotation <= max_rotation do
    turret
    |> angle_max_ccw
    |> Math.add(rotation)
    |> normalize_angle
  end

  def angle_max_ccw(%__MODULE__{max_ccw_angle: angle}), do: angle

  def angle_max_cw(%__MODULE__{max_ccw_angle: angle, max_rotation: rotation}) do
    normalize_angle(angle + rotation)
  end

  def angle_current(turret), do: get_angle(turret)

  def angle_random_in_arc(%__MODULE__{max_rotation: max_rotation} = turret) do
    rotation = (max_rotation * Enum.random(1..99) / 100)
    angle_for_given_rotation(turret, rotation)
  end

  def gun_barrel_vector(%__MODULE__{sprite: sprite}) do
    %{x: x} =
      sprite
      |> Sprite.mounts
      |> List.first
      |> position_new
    {x, 0}
  end

  def rotation_current(mount) do
    rotation_from_angle(mount, angle_current(mount))
  end

  def rotation_from_angle(mount, angle) do
    angle = normalize_angle(angle)
    angle = if angle < mount.max_ccw_angle do
      angle + 360
    else
      angle
    end
    angle - mount.max_ccw_angle
  end

  def rotation_half_max(%__MODULE__{max_rotation: value}), do: value / 2

  defp target_in_arc?(mount, target_unit_vector) do
    angle_between =
      mount
      |> vector_arc_center
      |> angle_between_vectors(target_unit_vector)
    angle_between <= rotation_half_max(mount)
  end

  def travel_from_current_angle(mount, angle) do
    rotation_from_angle(mount, angle) - rotation_current(mount)
  end

  def vector_arc_center(mount) do
    mount
    |> angle_at_half_rotation
    |> Vector.from_angle
  end

  # *** *******************************
  # *** BOUNDARY

  def normalize_desired_angle(%__MODULE__{} = mount, angle) when is_number(angle) do
    vector_desired = Vector.from_angle(angle)
    vector_arc_center = vector_arc_center(mount)
    cond do
      target_in_arc?(mount, vector_desired) ->
        {:ok, angle}
      angle_relative_to_vector(vector_desired, vector_arc_center) > 180 ->
        {:corrected, angle_max_ccw(mount)}
      true ->
        {:corrected, angle_max_cw(mount)}
    end
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do
    alias Dreadnought.Core.Turret
    def get_csys(turret), do: csys_from_pose(turret)
    # This no longer seems necessary, now that pose is on the item itself
    def get_angle(turret), do: Turret.angle_current(turret)
  end

  defimpl Inspect do
    use Spatial.PositionOrientationSize
    require IOP
    def inspect(turret, opts) do
      IOP.struct("Turret-#{turret.id}", [
        pose: pose_from_map(turret)
      ])
    end
  end
end
