alias Chukinas.Geometry.{Position, Rect, CollidableShape}

defmodule Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, meaning it comprises only horizontal and vertical lines.
  """

  require Position

  use TypedStruct

  typedstruct enforce: true do
    field :start_position, Position.t()
    field :end_position, Position.t()
  end

  # *** *******************************
  # *** NEW

  def new(start_x, start_y, end_x, end_y) do
    %__MODULE__{
      start_position: Position.new(start_x, start_y),
      end_position: Position.new(end_x, end_y)
    }
  end
  def new(start_position, end_position) when Position.is(start_position) and Position.is(end_position) do
    %__MODULE__{
      start_position: start_position,
      end_position: end_position
    }
  end
  def new(width, height) when is_number(width) and is_number(height) do
    %__MODULE__{
      start_position: Position.origin(),
      end_position: Position.new(width, height)
    }
  end

  # *** *******************************
  # *** API

  def contains?(%__MODULE__{} = rect, position) when Position.is(position) do
    Position.gte(position, rect.start_position) && Position.lte(position, rect.end_position)
  end

  def subtract(%__MODULE__{} = rect, position) when Position.is(position) do
    new_rect = new(
      rect.start_position |> Position.subtract(position),
      rect.end_position |> Position.subtract(position)
    )
    new_rect
  end

  def apply_margin(%__MODULE__{} = rect, margin) when is_number(margin) do
    rect
    |> Map.update!(:start_position, &(Position.subtract(&1, margin)))
    |> Map.update!(:end_position, &(Position.add(&1, margin)))
  end

  def get_size(%__MODULE__{} = rect) do
    %{x: width, y: height} = Position.subtract(rect.end_position, rect.start_position)
    %{width: width, height: height}
  end

  def get_start_position(%__MODULE__{start_position: start_position}), do: start_position
  def get_end_position(%__MODULE__{end_position: end_position}), do: end_position

  def list_vertices(rect) do
    size = get_size rect
    [
      rect.start_position,
      rect.start_position |> Position.add(size.width, 0),
      rect.end_position,
      rect.start_position |> Position.add(size.height, 0),
    ]
    |> IOP.inspect("rect points")
    |> Enum.map(&Position.to_vertex/1)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(rect), do: Rect.list_vertices(rect)
  end
end
