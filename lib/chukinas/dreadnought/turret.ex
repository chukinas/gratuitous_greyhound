
alias Chukinas.Dreadnought.{Turret, Sprite}
alias Chukinas.Geometry.{Pose, Trig}
alias Chukinas.LinearAlgebra.{HasCsys, CSys, Vector}

# TODO rename Mount
defmodule Turret do
  @moduledoc """
  Represents a weapon on a unit (ship, fortification, etc)
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    # TODO I need coords relative to the unit's origin. These poses are all relative to top-left of sprite
    field :vector_position, Vector.t()
    field :resting_pose, Pose.t()
    # TODO this is duplicate information
    field :arc, {start_angle :: integer(), end_angle :: integer()}
    field :min_angle, degrees :: number()
    field :max_travel, positive_degrees :: number()
    # TODO this pose should be just a simple angle instead, as the location is fully captured in :resting_pose
    field :pose, Pose.t()
    field :sprite, Sprite.t()
  end

  # *** *******************************
  # *** NEW

  # TODO get rid of pose. I should be able to position mounts in unit3 using just the origin.
  def new(id, pose, sprite, vector_position) do
    %__MODULE__{
      id: id,
      vector_position: vector_position,
      resting_pose: pose,
      arc: default_arc(pose),
      min_angle: Trig.normalize_angle(pose.angle - 135),
      max_travel: 270,
      pose: pose,
      sprite: sprite
    }
  end

  # *** *******************************
  # *** GETTERS

  def max_angle(mount), do: mount.min_angle + mount.max_travel
  def angle_arc_center(mount) do
    Trig.normalize_angle(mount.min_angle + (mount.max_travel / 2))
  end
  def vector_arc_center(mount) do
    mount
    |> angle_arc_center
    |> Vector.from_angle
  end
  def unit_vector_arc_center(mount) do
    mount
    |> angle_arc_center
    |> Vector.from_angle
  end
  def current_angle(mount), do: mount.pose.angle
  def current_rel_angle(mount) do
    rel_angle(mount, current_angle(mount))
  end
  def half_travel(%__MODULE__{max_travel: travel}), do: travel / 2
  # TODO implement
  def gun_barrel_length(_mount), do: 2
  def gun_barrel_vector(mount), do: {gun_barrel_length(mount), 0}
  def pose(%{vector_position: {x, y}, pose: pose}) do
    Pose.new(x, y, Pose.angle(pose))
  end
  def csys(turret), do: turret |> pose |> CSys.new

  # *** *******************************
  # *** SETTERS

  def put_angle(mount, angle) do
    Map.update!(mount, :pose, &Pose.put_angle(&1, angle))
  end

  # *** *******************************
  # *** API

  def normalize_desired_angle(%__MODULE__{} = mount, angle) do
    vector_desired = Vector.from_angle(angle)
    vector_arc_center = vector_arc_center(mount)
    cond do
      lies_within_arc?(mount, vector_desired) -> {:ok, angle}
      Vector.sign_between(vector_arc_center, vector_desired) < 0 -> {:corrected, mount.min_angle}
      true -> {:corrected, max_angle(mount)}
    end
  end

  # TODO bad name
  def rel_angle(mount, angle) do
    angle = Trig.normalize_angle(angle)
    angle = if angle < mount.min_angle do
      angle + 360
    else
      angle
    end
    angle - mount.min_angle
  end

  # TODO also bad name
  def travel(mount, angle) do
    rel_angle(mount, angle) - current_rel_angle(mount)
  end

  def gunfire_pose(mount, unit) do
    position_vector =
      mount
      |> gun_barrel_vector
    # TODO combine these into a new simple API: Csys.Conversion.get_world_vector
      |> CSys.Conversion.new
      |> CSys.Conversion.put(mount)
      |> CSys.Conversion.put(unit)
      |> CSys.Conversion.get_vector
    angle = CSys.Conversion.sum_angles(mount, unit)
    Pose.new(position_vector, angle)
  end

  # *** *******************************
  # *** PRIVATE

  defp default_arc(resting_pose) do
    rest_angle = resting_pose.angle
    start_angle = rest_angle - (90 + 45)
    end_angle = rest_angle - 90
    {
      Trig.normalize_angle(start_angle),
      Trig.normalize_angle(end_angle)
    }
  end

  defp lies_within_arc?(mount, target_unit_vector) do
    vector_arc_center = vector_arc_center(mount)
    angle_between = Vector.angle_between_abs(vector_arc_center, target_unit_vector)
    angle_between <= half_travel(mount)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(turret, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      fields = [
        pose: Turret.pose(turret)
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
    def get_csys(self), do: Turret.csys(self)
    def get_angle(%{pose: pose}), do: Pose.angle(pose)
  end
end
