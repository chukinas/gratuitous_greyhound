alias Chukinas.Geometry.{Rect, CollidableShape}
alias Chukinas.LinearAlgebra.Vector

defmodule Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, comprising only horizontal and vertical lines
  """

  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    position_fields()
    size_fields()
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

  def new(start_position, end_position)
  when has_position(start_position) and has_position(end_position) do
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

  # TODO rename position_bottom_right
  def bottom_right_position(%__MODULE__{} = rect) do
    rect
    |> position_from_size
    |> position_add(rect)
  end

  def list_vertices(rect) do
    # TODO rename vertices
    # TODO move getters to appropriate section
    position_top_left = position(rect)
    for pos <- [
      position_top_left,
      position_add_x(position_top_left, width(rect)),
      bottom_right_position(rect),
      position_add_y(position_top_left, height(rect))
    ], do: position_to_vertex(pos)
  end

  def center_position(rect) do
    relative_center =
      rect
      |> position_from_size
      |> position_divide(2)
    rect
    |> position_add(relative_center)
    |> position
  end
  def center_vector(rect), do: center_position(rect) |> Vector.new


  # *** *******************************
  # *** API

  def bounding_rect(rects) when is_list(rects) do
    {min, max} = position_min_max(rects ++ Enum.map(rects, &bottom_right_position/1))
    size = size_new(min, max)
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
    dist_from_origin = position(half_width, half_height)
    Rect.new(
      position_subtract(origin, dist_from_origin),
      position_add(origin, dist_from_origin)
    )
  end

  def scale(rect, scale) do
    rect
    |> position_multiply(scale)
    |> size_multiply(scale)
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
      pos = rect |> position |> IOP.doc
      size = rect |> size_new |> IOP.doc
      contents =
        pos
        |> concat(IOP.comma)
        |> glue(size)
      IOP.container("Rect", contents)
    end
  end
end
