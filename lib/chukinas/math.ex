defmodule Chukinas.Math do

  alias Chukinas.Geometry.Trig
  require Trig

  # *** *******************************
  # *** MACROS

  defmacro __using__(_opts) do
    # TODO do something with opts
    quote do
      require Chukinas.Math
      import Chukinas.Math
      alias Chukinas.Geometry.Trig
    end
  end

  defguard angle_is_normal(angle)
    when Trig.angle_is_normal(angle)

  # *** *******************************
  # *** FUNCTIONS

  def sign(x) when x <  0, do: -1
  def sign(x) when x == 0, do:  0
  def sign(x) when x >  0, do:  1

  def flip_sign(x), do: x * sign(x)

  def split_with_ratio(value, ratio) do
    new_val = value * ratio
    {new_val, value - new_val}
  end

  # *** *******************************
  # *** ANGLES

  def radius_from_angle_and_arclen(angle, arclen) do
    (360 * arclen) / (2 * :math.pi() * angle)
  end

  def angle_from_radius_and_arclen(radius, arclen) do
    (360 * arclen) / (2 * :math.pi() * radius)
  end

  def arclen_from_radius_and_angle(radius, angle) do
    (2 * :math.pi() * radius * angle) / 360
  end

end
