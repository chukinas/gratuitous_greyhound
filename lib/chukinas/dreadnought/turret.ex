alias Chukinas.Dreadnought.{Turret, Sprite, Mount}
alias Chukinas.Geometry.{Pose, Trig, Position, Pose}
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
    field :sprite, Sprite.t()
    field :min_angle, degrees :: number()
    field :max_travel, positive_degrees :: number()
    field :rest_angle, degrees :: number()
    field :pose, Pose.t()
  end

  # *** *******************************
  # *** NEW

  def new(id, sprite, pose) do
    rest_angle = Pose.angle(pose)
    %__MODULE__{
      id: id,
      sprite: sprite,
      min_angle: Trig.normalize_angle(rest_angle - 135),
      max_travel: 270,
      rest_angle: rest_angle,
      pose: pose
    }
  end

  # *** *******************************
  # *** GETTERS

  def max_angle(%__MODULE__{min_angle: angle, max_travel: travel}), do: angle + travel
  def angle_arc_center(%__MODULE__{min_angle: angle, max_travel: travel}) do
    Trig.normalize_angle(angle + (travel / 2))
  end
  def vector_arc_center(mount) do
    mount
    |> angle_arc_center
    |> Vector.from_angle
  end
  def current_angle(%__MODULE__{pose: pose}), do: Pose.angle(pose)
  def current_rel_angle(mount) do
    rel_angle(mount, current_angle(mount))
  end
  def half_travel(%__MODULE__{max_travel: travel}), do: travel / 2
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
  # TODO is neutral_csys a better name?
  def inline_csys(turret) do
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

  # *** *******************************
  # *** PRIVATE

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
    def get_csys(self), do: Turret.csys(self)
    def get_angle(%{pose: pose}), do: Pose.angle(pose)
  end
end
