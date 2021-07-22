defmodule Chukinas.Math do

  # *** *******************************
  # *** MACROS

  defmacro __using__(_opts) do
    # TODO do something with opts
    quote do
      require Chukinas.Math
      import Chukinas.Math
    end
  end

  # *** *******************************
  # *** FUNCTIONS

  def sign(x) when is_number(x) do
    cond do
      x <  0 -> -1
      x == 0 ->  0
      x >  0 ->  1
    end
  end

  def flip_sign(x), do: x * sign(x)

  def split_with_ratio(value, ratio) do
    new_val = value * ratio
    {new_val, value - new_val}
  end

  # *** *******************************
  # *** ARCS

  def angle_from_radius_and_arclen(radius, arclen) do
    (360 * arclen) / (2 * :math.pi() * radius)
  end

  def arclen_from_radius_and_angle(radius, angle) do
    (2 * :math.pi() * radius * angle) / 360
  end

  def radius_from_angle_and_arclen(angle, arclen) do
    (360 * arclen) / (2 * :math.pi() * angle)
  end

  # *** *******************************
  # *** PIPE BASIC OPERATORS

  def add(a, b), do: a + b

  def subtract(a, b), do: a - b

  def mult(a, b), do: a * b

  def divide(a, b), do: a / b

  # *** *******************************
  # *** TRIG

  def asin(value), do: :math.asin(value) |> rad_to_deg


  def sin_and_cos(0), do: {0, 1}
  def sin_and_cos(90), do: {1, 0}
  def sin_and_cos(180), do: {0, -1}
  def sin_and_cos(-90), do: {-1, 0}
  def sin_and_cos(270), do: {-1, 0}
  def sin_and_cos(deg) do
    rad = deg_to_rad(deg)
    {:math.sin(rad), :math.cos(rad)}
  end

  def sin(degrees) do
    degrees
    |> deg_to_rad()
    |> :math.sin()
  end

  def cos(degrees) do
    degrees
    |> deg_to_rad()
    |> :math.cos()
  end

  def acos(value), do: :math.acos(value) |> rad_to_deg

  # *** *******************************
  # *** ANGLE CONVERSIONS

  defguard angle_is_normal(angle)
    when angle >= 0
    and angle < 360

  def normalize_angle(angle) when is_number(angle) do
    cond do
      angle < 0 ->
        normalize_angle(angle + 360)
      angle >= 360 ->
        normalize_angle(angle - 360)
      true ->
        angle
    end
  end

  def deg_to_rad(angle), do: angle * :math.pi() / 180

  def rad_to_deg(angle), do: angle * 180 / :math.pi()

end
