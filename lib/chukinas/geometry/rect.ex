alias Chukinas.Geometry.{Position, Point}

defmodule Chukinas.Geometry.Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, meaning it comprises only horizontal and vertical lines.
  """

  use TypedStruct

  typedstruct enforce: true do
    field :start_position, Point.t()
    field :end_position, Point.t()
  end

  # *** *******************************
  # *** NEW

  def new(start_position, end_position) do
    %__MODULE__{
      start_position: start_position,
      end_position: end_position
    }
  end

  # *** *******************************
  # *** API

  # TODO create position guard `has_position` or `is_position`?
  def contains?(%__MODULE__{} = rect, position) do
    Position.gte(position, rect.start_position) && Position.lte(position, rect.end_position)
  end

end
