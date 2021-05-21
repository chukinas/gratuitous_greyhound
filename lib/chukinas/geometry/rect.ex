alias Chukinas.Geometry.{Position, Rect, CollidableShape, Size}
alias Chukinas.LinearAlgebra.Vector

defmodule Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, comprising only horizontal and vertical lines
  """

  require Position

  # *** *******************************
  # *** TYPES

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
  def new(%{x: x, y: y}, %{width: width, height: height}) do
    %__MODULE__{
      x: x,
      y: y,
      width: width,
      height: height
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
  # *** GETTERS

  def bottom_right_position(%__MODULE__{} = rect) do
    rect
    |> Position.from_size
    |> Position.add(rect)
  end

  def list_vertices(%{x: x, y: y, width: width, height: height}) do
    # TODO rename vertices
    # TODO move getters to appropriate section
    position = Position.new(x, y)
    [
      position,
      Position.add_x(position, width),
      # TODO replace with bottom_right_position
      Position.add(position, width, height),
      Position.add_y(position, height)
    ]
    |> Enum.map(&Position.to_vertex/1)
  end

  def center_position(rect) do
    relative_center =
      rect
      |> Position.from_size
      |> Position.divide(2)
    rect
    |> Position.add(relative_center)
    |> Position.new
  end
  def center_vector(rect), do: center_position(rect) |> Vector.new


  # *** *******************************
  # *** API

  def bounding_rect(rects) when is_list(rects) do
    {min, max} = Position.min_max(rects ++ Enum.map(rects, &bottom_right_position/1))
    size = Size.from_positions(min, max)
    new(min, size)
  end
  def bounding_rect(%__MODULE__{} = a, %__MODULE__{} = b) do
    bounding_rect([a, b])
  end

  def get_centered_rect(origin, rect) do
    # This returns the smallest rect that contains the origin rect and is centered on the origin
    # TODO is this used anymore?
    half_width = max(
      abs(origin.x - rect.x),
      abs(rect.x + rect.width - origin.x)
    )
    half_height = max(
      abs(origin.y - rect.y),
      abs(rect.y + rect.height - origin.y)
    )
    dist_from_origin = Position.new(half_width, half_height)
    Rect.new(
      Position.subtract(origin, dist_from_origin),
      Position.add(origin, dist_from_origin)
    )
  end

  def scale(rect, scale) do
    rect
    |> Position.multiply(scale)
    |> Size.multiply(scale)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(rect), do: Rect.list_vertices(rect)
  end

  defimpl Inspect do
    import Inspect.Algebra
    require IOP
    def inspect(rect, opts) do
      pos = rect |> Position.new |> IOP.doc
      size = rect |> Size.new |> IOP.doc
      contents =
        pos
        |> concat(IOP.comma)
        |> glue(size)
      IOP.container("Rect", contents)
    end
  end
end
