# TODO rename file
alias Chukinas.Geometry.{Shape, CollidableShape}

defmodule Shape do
  @moduledoc"""
  An arbitrary 2D shape composed of straight edges
  """

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  # TODO remove the auto use of typestruct from POS
  use TypedStruct

  typedstruct enforce: true do
    # TODO use list of coords
    field :coords, [any]
  end

  # *** *******************************
  # *** NEW

  def from_coords(coords) when length(coords) > 2 do
    Enum.each(coords, fn coord -> true = is_coord(coord) end)
    %__MODULE__{
      coords: coords
    }
  end

  # *** *******************************
  # *** GETTERS

  def coords(%__MODULE__{coords: val}), do: val

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_coords(polygon), do: Shape.coords(polygon)
  end

end
