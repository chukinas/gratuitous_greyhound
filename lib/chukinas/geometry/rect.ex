alias Chukinas.Geometry.{Position, Point, Rect}

defmodule Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, meaning it comprises only horizontal and vertical lines.
  """

  import Position.Guard

  use TypedStruct

  typedstruct enforce: true do
    field :start_position, Point.t()
    field :end_position, Point.t()
  end

  # *** *******************************
  # *** NEW

  def new(start_position, end_position) when has_position(start_position) and has_position(end_position) do
    %__MODULE__{
      start_position: start_position,
      end_position: end_position
    }
  end
  def new(width, height) when is_number(width) and is_number(height) do
    %__MODULE__{
      start_position: Point.origin(),
      end_position: Point.new(width, height)
    }
  end

  # *** *******************************
  # *** API

  def contains?(%__MODULE__{} = rect, position) when has_position(position) do
    Position.gte(position, rect.start_position) && Position.lte(position, rect.end_position)
  end

end
