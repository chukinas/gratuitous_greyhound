
alias Chukinas.Dreadnought.{Turret, Sprite}
alias Chukinas.Geometry.{Pose, Trig}
alias Chukinas.LinearAlgebra.Vector

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

  def new(id, pose, sprite) do
    %__MODULE__{
      id: id,
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
    mount.min_angle + (mount.max_travel / 2)
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

  # *** *******************************
  # *** SETTERS

  def put_angle(mount, angle) do
    Map.update!(mount, :pose, &Pose.put_angle(&1, angle))
  end

  # *** *******************************
  # *** API

  def normalize_desired_angle(%__MODULE__{} = mount, angle) do
    vector_desired = Vector.from_angle(angle)
    vector_arc_center = Vector.from_angle(mount |> angle_arc_center)
    angle_between = Vector.angle_between(vector_arc_center, vector_desired)
    cond do
      angle_between <= (mount.max_travel / 2) -> {:ok, angle}
      angle_between <= 180 -> {:corrected, max_angle(mount)}
      true -> {:corrected, mount.min_angle}
    end
  end

  def rel_angle(mount, angle) do
    angle = Trig.normalize_angle(angle)
    angle = if angle < mount.min_angle do
      angle + 360
    else
      angle
    end
    angle - mount.min_angle
  end

  def travel(mount, angle) do
    rel_angle(mount, angle) - current_rel_angle(mount)
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

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(turret, opts) do
      fields = [
        rest: turret.resting_pose,
        pose: turret.pose
      ]
      concat [
        "#Turret-#{turret.id}<",
        to_doc(turret.min_angle, opts),
        "°+",
        to_doc(turret.max_travel, opts),
        " ",
        to_doc(fields, opts), ">"
      ]
    end
  end
end
