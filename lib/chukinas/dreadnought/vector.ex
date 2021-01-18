defmodule Chukinas.Dreadnought.Vector do
  @moduledoc """
  Struct and functions for operating on vectors.

  Given a vector (i.e. a point and an orientation), we can...
  - move along it some distance in a straight line
  - follow an arc to the right or left until some distance or orientation is reached
  """

  alias Chukinas.Dreadnought.Angle
  alias Chukinas.Dreadnought.Point
  import Chukinas.Dreadnought.Guards

  # *** *******************************
  # *** TYPE

  use TypedStruct

  typedstruct enforce: true do
    field :point, Point.t()
    field :angle, Angle.t()
  end

  # *** *******************************
  # *** NEW

  @doc """
  Construct new Vector struct

  ## Examples

      iex> Vector.new(1, 2, 0)
      %Vector{point: {1, 2}, angle: %Chukinas.Dreadnought.Angle{deg: 0, deg_abs: 0, negative?: false, rad: 0.0, rad_abs: 0.0}}

      iex> point = {1, 2}
      iex> angle = Chukinas.Dreadnought.Angle.new(0)
      iex> Vector.new(point, angle)
      %Vector{point: {1, 2}, angle: %Chukinas.Dreadnought.Angle{deg: 0, deg_abs: 0, negative?: false, rad: 0.0, rad_abs: 0.0}}
  """
  def new(x, y, angle_deg) when is_number(x) and is_number(y) and is_number(angle_deg) do
    %__MODULE__{
      point: {x, y},
      angle: Angle.new(angle_deg)
    }
  end
  def new(point, %Angle{}=angle) when is_point(point) do
    %__MODULE__{
      point: point,
      angle: angle
    }
  end

  # *** *******************************
  # *** TO MAP

  @doc """
  Get a simplified representation of a Vector struct

  Originally created to ease the process of writing this modules's doctests.

  ## Examples

      iex> Vector.new(1, 2, 90)
      ...> |> Vector.to_map()
      %{x: 1, y: 2, angle_deg: 90}
  """
  def to_map(%__MODULE__{}=vector) do
    {x, y} = vector.point
    %{
      x: x,
      y: y,
      angle_deg: vector.angle.deg
    }
  end

  # *** *******************************
  # *** MOVE STRAIGHT

  @doc """
  Move some distance along the vector

  ## Examples

      iex> Vector.new(1, 2, 90)
      ...> |> Vector.move_straight(1)
      ...> |> Vector.to_map()
      %{x: 1.0, y: 3.0, angle_deg: 90}
  """
  def move_straight(%__MODULE__{}=vector, distance) do
    vector.angle
    |> Point.from_polar(distance)
    |> Point.add(vector.point)
    |> new(vector.angle)
  end
end
