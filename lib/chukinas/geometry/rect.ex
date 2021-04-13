alias Chukinas.Geometry.{Position, Rect, CollidableShape}

defmodule Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, comprising only horizontal and vertical lines
  """

  require Position

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :width, number()
    field :height, number()
  end

  # *** *******************************
  # *** NEW

  def new(start_x, start_y, end_x, end_y) do
    %__MODULE__{
      x: start_x,
      y: start_y,
      width: abs(start_x - end_x),
      height: abs(start_y - end_y)
    }
  end
  def new(start_position, end_position) when Position.is(start_position) and Position.is(end_position) do
    %__MODULE__{
      x: start_position.x,
      y: start_position.y,
      width: abs(start_position.x - end_position.x),
      height: abs(start_position.y - end_position.y)
    }
  end
  def new(width, height) when is_number(width) and is_number(height) do
    %__MODULE__{
      x: 0,
      y: 0,
      width: abs(width),
      height: abs(height)
    }
  end

  # *** *******************************
  # *** API

  def list_vertices(%{x: x, y: y, width: width, height: height}) do
    position = Position.new(x, y)
    [
      position,
      Position.add_x(position, width),
      Position.add(position, width, height),
      Position.add_y(position, height)
    ]
    |> Enum.map(&Position.to_vertex/1)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(rect), do: Rect.list_vertices(rect)
  end
end
