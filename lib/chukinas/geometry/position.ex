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
  def subtract(position, number) when is_number(number) do
    subtract(position, number, number)
  end
  def subtract(position, translation) do
    translate(position, {-translation.x, -translation.y})
  end

  def round_to_int(position) do
    position
    |> Map.update!(:x, &round/1)
    |> Map.update!(:y, &round/1)
  end

  def gt(position1, position2) do
    position1.x > position2 && position1.y > position2.y
  end

  def gte(position1, position2) do
    position1.x >=  position2.x && position1.y >=  position2.y
  end

  def lte(position1, position2) do
    position1.x <=  position2.x && position1.y <=  position2.y
  end

  def get(position) do
    take(position)
  end

  # TODO replace with get
  def take(position) do
    position |> Map.take([:x, :y])
  end

  # *** *******************************
  # *** PRIVATE

  defp sanitize_translation({x, y}), do: %{x: x, y: y}
  defp sanitize_translation(%{x: x, y: y}), do: %{x: x, y: y}

end
