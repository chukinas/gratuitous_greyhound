defmodule Chukinas.Geometry.Trig do

  # *** *******************************
  # *** API

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
      not vertical? -> :math.atan(opposite / adjacent) |> rad_to_deg
      opposite > 0 -> 90
      true -> 270
    end
  end

  def asin(value), do: :math.asin(value) |> rad_to_deg

  # *** *******************************
  # *** PRIVATE

  def deg_to_rad(angle), do: angle * :math.pi() / 180
  def rad_to_deg(angle), do: angle * 180 / :math.pi()
  def opposite_and_adjacent(a, b) do
    opposite = b.y - a.y
    adjacent = b.x - a.x
    {opposite, adjacent}
  end

end
