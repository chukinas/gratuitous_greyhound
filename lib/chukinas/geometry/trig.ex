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

  # *** *******************************
  # *** PRIVATE

  def deg_to_rad(angle), do: angle * :math.pi() / 180

end
