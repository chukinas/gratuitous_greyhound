defmodule Chukinas.Geometry.Trig do

  # *** *******************************
  # *** API

  def mult(a, b), do: a * b

  def sign(value) when value <  0, do: -1
  def sign(value) when value >= 0, do:  1

  def acos(value), do: :math.acos(value) |> rad_to_deg

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

  def distance_between_points(a, b) do
    :math.sqrt(:math.pow(a.x - b.x, 2) + :math.pow(a.y - b.y, 2))
  end

  def deg_between_points(a, b) do
    {opposite, adjacent} = opposite_and_adjacent a, b
    vertical? = adjacent * 1.0 == 0.0
    cond do
      vertical? and opposite > 0 ->
        90
      vertical? ->
        -90
      _in_right_quadrants = adjacent > 0 ->
        :math.atan(opposite / adjacent) |> rad_to_deg |> normalize_angle
      true ->
        :math.atan(opposite / adjacent) |> rad_to_deg |> add_180 |> normalize_angle
    end
  end

  def asin(value), do: :math.asin(value) |> rad_to_deg

  def arc_length(radius, angle) do
    2 * radius * :math.pi() * angle / 360
  end

  def normalize_angle(angle) do
    cond do
      angle < 0 ->
        normalize_angle(angle + 360)
      angle >= 360 ->
        normalize_angle(angle - 360)
      true ->
        angle
    end
  end

  # *** *******************************
  # *** PRIVATE

  def deg_to_rad(angle), do: angle * :math.pi() / 180
  def rad_to_deg(angle), do: angle * 180 / :math.pi()
  def opposite_and_adjacent(a, b) do
    opposite = b.y - a.y
    adjacent = b.x - a.x
    {opposite, adjacent}
  end
  defp add_180(angle), do: angle + 180
end
