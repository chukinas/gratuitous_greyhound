alias Chukinas.Dreadnought.{Turret, Sprite, Mount}
alias Chukinas.Geometry.{Pose, Trig, Position, Pose}
alias Chukinas.LinearAlgebra.{HasCsys, CSys, Vector}

defmodule Turret do
  @moduledoc """
  Represents a weapon on a unit (ship, fortification, etc)

  Definitions:
  ANGLE: orientation of turret relative to ship (e.g. a rear turret at rest has an angle of 180deg).
  ROTATION: orientation of turret relative to its own maximum CCW angle. Always a positive number.
  TRAVEL: movement / arc of a turret, where positive numbers are CW and negative are CCW.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :sprite, Sprite.t()
    field :max_ccw_angle, degrees :: number()
    field :max_rotation, positive_degrees :: number()
    field :rest_angle, degrees :: number()
    field :pose, Pose.t()
  end

  # *** *******************************
  # *** NEW

  def new(id, sprite, pose) do
    rest_angle =
      pose
      |> Pose.angle
      |> Trig.normalize_angle
    %__MODULE__{
      id: id,
      sprite: sprite,
      max_ccw_angle: Trig.normalize_angle(rest_angle - 135),
      max_rotation: 270,
      rest_angle: rest_angle,
      pose: pose
    }
  end

  # *** *******************************
  # *** GETTERS

  def angle_max_ccw(%__MODULE__{max_ccw_angle: angle}), do: angle
  def angle_max_cw(%__MODULE__{max_ccw_angle: angle, max_rotation: rotation}) do
    Trig.normalize_angle(angle + rotation)
  end
  def angle_arc_center(%__MODULE__{max_ccw_angle: angle} = turret) do
    Trig.normalize_angle(angle + half_travel(turret))
  end
  def vector_arc_center(mount) do
    mount
    |> angle_arc_center
    |> Vector.from_angle
  end
  def current_angle(%__MODULE__{pose: pose}), do: Pose.angle(pose)
  def current_rotation(mount) do
    rotation(mount, current_angle(mount))
  end
  def half_travel(%__MODULE__{max_rotation: rotation}), do: rotation / 2
  def gun_barrel_vector(%__MODULE__{sprite: sprite}) do
    %{x: x} =
      sprite
      |> Sprite.mounts
      |> List.first
      |> Mount.position
    {x, 0}
  end
  def pose(%__MODULE__{pose: pose}), do: pose
  def position(%__MODULE__{pose: pose}), do: Position.new(pose)
  def csys(turret), do: turret |> pose |> CSys.new
  def position_csys(turret) do
    turret
    |> position
    |> CSys.new
  end

  # *** *******************************
  # *** SETTERS

  def put_angle(mount, angle) do
    Map.update!(mount, :pose, &Pose.put_angle(&1, angle))
  end

  # *** *******************************
  # *** API

  def normalize_desired_angle(%__MODULE__{} = mount, angle) when is_number(angle) do
    vector_desired = Vector.from_angle(angle)
    vector_arc_center = vector_arc_center(mount)
    cond do
      lies_within_arc?(mount, vector_desired) -> {:ok, angle}
      Vector.sign_between(vector_arc_center, vector_desired) < 0 -> {:corrected, angle_max_ccw(mount)}
      true -> {:corrected, angle_max_cw(mount)}
    end
  end

  def rotation(mount, angle) do
    angle = Trig.normalize_angle(angle)
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

  # *** *******************************
  # *** PRIVATE

  defp lies_within_arc?(mount, target_unit_vector) do
    angle_between =
      mount
      |> vector_arc_center
      |> Vector.angle_between_abs(target_unit_vector)
    angle_between <= half_travel(mount)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(turret, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      fields = [
        pose: Turret.pose(turret),
        mounts: turret.sprite.mounts
      ]
      concat [
        col.("#Turret-#{turret.id}<"),
        to_doc(Turret.angle_arc_center(turret) |> round, opts),
        "±",
        to_doc(Turret.half_travel(turret) |> round, opts),
        "°",
        to_doc(fields, opts),
        col.(">")
      ]
    end
  end

  defimpl HasCsys do
    def get_csys(turret), do: Turret.csys(turret)
    def get_angle(turret), do: Turret.current_angle(turret)
  end
end
