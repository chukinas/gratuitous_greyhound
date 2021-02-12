alias Chukinas.Geometry.{Position}

defmodule Position do

  # *** *******************************
  # *** TYPES

  @type position_tuple() :: {number(), number()}

  # *** *******************************
  # *** API

  def to_tuple(%{x: x, y: y}), do: {x, y}

  def translate(positionable, translation) do
    Map.merge(positionable, sanitize_translation(translation), fn _k, orig, trans ->
      orig + trans
    end)
  end

  def subtract(position, x, y), do: translate(position, {-x, -y})
  def subtract(position, translation) do
    translate(position, {-translation.x, -translation.y})
  end

  # *** *******************************
  # *** PRIVATE

  defp sanitize_translation({x, y}), do: %{x: x, y: y}
  defp sanitize_translation(%{x: x, y: y}), do: %{x: x, y: y}

end
