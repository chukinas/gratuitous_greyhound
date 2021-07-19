defmodule Chukinas.Dreadnought.Turret do

  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  use Chukinas.Math
  alias Chukinas.Dreadnought.Sprites
  alias Chukinas.LinearAlgebra.HasCsys
  alias Chukinas.LinearAlgebra.Vector

  # *** *******************************
  # *** NEW

  typedstruct enforce: true do
    field :id, integer()
    field :sprite, Sprites.t
    field :max_ccw_angle, degrees :: number()
    field :max_rotation, positive_degrees :: number()
    field :rest_angle, degrees :: number()
    pose_fields()
  end

  # *** *******************************
  # *** NEW

  def new(id, sprite, pose) do
    rest_angle =
      pose
      |> angle_normalize
      |> angle
    fields =
      %{
        id: id,
        sprite: sprite,
        max_ccw_angle: normalize_angle(rest_angle - 135),
        max_rotation: 270,
        rest_angle: rest_angle,
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def angle_max_ccw(%__MODULE__{max_ccw_angle: angle}), do: angle

  def angle_max_cw(%__MODULE__{max_ccw_angle: angle, max_rotation: rotation}) do
    normalize_angle(angle + rotation)
  end

  def angle_arc_center(%__MODULE__{max_ccw_angle: angle} = turret) do
    normalize_angle(angle + half_travel(turret))
  end

  def vector_arc_center(mount) do
    mount
    |> angle_arc_center
    |> Vector.from_angle
  end

  def current_angle(turret), do: get_angle(turret)

  def current_rotation(mount) do
    rotation(mount, current_angle(mount))
  end

  def half_travel(%__MODULE__{max_rotation: rotation}), do: rotation / 2

  def gun_barrel_vector(%__MODULE__{sprite: sprite}) do
    %{x: x} =
      sprite
      |> Sprites.mounts
      |> List.first
      |> position_new
    {x, 0}
  end

  def get_pose(turret), do: pose_new(turret)

  def get_position(turret), do: position_new(turret)

  def csys(turret), do: turret |> csys_new

  def position_csys(turret) do
    turret
    |> get_position
    |> csys_new
  end

  # *** *******************************
  # *** SETTERS

  defdelegate put_angle(mount, angle), to: POS, as: :put_angle!

  # *** *******************************
  # *** API

  def normalize_desired_angle(%__MODULE__{} = mount, angle) when is_number(angle) do
    vector_desired = Vector.from_angle(angle)
    vector_arc_center = vector_arc_center(mount)
    cond do
      lies_within_arc?(mount, vector_desired) -> {:ok, angle}
      angle_relative_to_vector(vector_desired, vector_arc_center) > 180 -> {:corrected, angle_max_ccw(mount)}
      true -> {:corrected, angle_max_cw(mount)}
    end
  end

  def rotation(mount, angle) do
    angle = normalize_angle(angle)
    angle = if angle < mount.max_ccw_angle do
      angle + 360
    else
      angle
    end
    angle - mount.max_ccw_angle
  end

  def travel_from_current_angle(mount, angle) do
    rotation(mount, angle) - current_rotation(mount)
  end

  defp lies_within_arc?(mount, target_unit_vector) do
    angle_between =
      mount
      |> vector_arc_center
      |> angle_between_vectors(target_unit_vector)
    angle_between <= half_travel(mount)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do
    alias Chukinas.Dreadnought.Turret
    def get_csys(turret), do: Turret.csys(turret)
    # This no longer seems necessary, now that pose is on the item itself
    def get_angle(turret), do: Turret.current_angle(turret)
  end

  defimpl Inspect do
    alias Chukinas.PositionOrientationSize, as: POS
    require IOP
    def inspect(turret, opts) do
      IOP.struct("Turret-#{turret.id}", [
        pose: POS.pose_new(turret)
      ])
    end
  end
end
