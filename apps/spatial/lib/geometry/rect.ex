defmodule Spatial.Geometry.Rect do
  @moduledoc"""
  A Rect is an in-grid rectangle, comprising only horizontal and vertical lines

  Its position is the position of the top-left corner.
  """

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
    use Spatial.TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    rect_fields()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_centered_square(position, size) do
    from_position_and_size(
      position |> position_subtract(size / 2),
      size_new(size, size)
    )
  end

  def from_position_and_size(%{x: x, y: y}, %{width: width, height: height}) do
    new(x, y, width, height)
  end

  def from_positions({min_position, max_position}) do
    from_positions(min_position, max_position)
  end

  def from_positions(start_position, end_position) do
    from_position_and_size(
      start_position,
      size_from_positions(start_position, end_position)
    )
  end

  def from_positions(start_x, start_y, end_x, end_y) do
    from_positions(
      position_new(start_x, start_y),
      position_new(end_x, end_y)
    )
  end

  def from_rect(%__MODULE__{} = rect), do: rect

  def from_rect(%{x: x, y: y, width: width, height: height}) do
    new(x, y, width, height)
  end

  def from_map(%{x: x, y: y, width: width, height: height}) do
    new(x, y, width, height)
  end

  def from_size(%{width: width, height: height}) do
    new(0, 0, width, height)
  end

  def from_size(width, height) when is_number(width) and is_number(height) do
    new(0, 0, abs(width), abs(height))
  end

  def null do
    new(0, 0, 0, 0)
  end

  def new(x, y, width, height) do
    %__MODULE__{
      x: x,
      y: y,
      width: width,
      height: height
    }
  end

  # *** *******************************
  # *** GETTERS

  # TODO rename position_bottom_right
  def bottom_right_position(rect) do
    rect
    |> position_from_size
    |> position_add(rect)
  end

  def to_coords(rect) do
    # TODO rename vertices
    # TODO move getters to appropriate section
    position_top_left = position(rect)
    relative_position_br = rect |> position_from_size
    for position <- [
      position_top_left,
      position_add_x(position_top_left, relative_position_br),
      bottom_right_position(rect),
      position_add_y(position_top_left, relative_position_br)
    ], do: vector_from_position(position)
  end

  def center_position(rect) do
    rect
    |> position_from_size
    |> position_divide(2)
    |> position_add(rect)
    |> position_new
  end

  def center_vector(rect), do: rect |> center_position |> position_to_tuple


  # *** *******************************
  # *** API

  def bounding_rect_from_positions(list) do
    list
    |> position_min_max
    |> from_positions
  end

  def bounding_rect(rects) when is_list(rects) do
    bounding_rect_from_positions(rects ++ Enum.map(rects, &bottom_right_position/1))
  end

  def bounding_rect(a, b)
  when has_position_and_size(a)
  and has_position_and_size(b) do
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
    from_positions(
      position_subtract(origin, dist_from_origin),
      position_add(origin, dist_from_origin)
    )
  end

  def scale(rect, scale) do
    rect
    |> position_multiply(scale)
    |> size_multiply(scale)
  end

  def merge_rect(map, rect_map) do
    rect = from_rect(rect_map) |> Map.from_struct
    Map.merge(map, rect)
  end

  # *** *******************************
  # *** REDUCERS

  def grow(rect, addition) do
    rect
    |> position_subtract(addition)
    |> size_add(2 * addition)
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Spatial.Geometry.Rect

defimpl Spatial.Collide.IsShape, for: Rect do
  def to_coords(rect), do: Rect.to_coords(rect)
end

defimpl Inspect, for: Rect do
  import Inspect.Algebra
  require IOP
  use Spatial.PositionOrientationSize
  def inspect(rect, opts) do
    pos = rect |> position_new |> IOP.doc
    size = rect |> size_new |> IOP.doc
    contents =
      pos
      |> concat(IOP.comma)
      |> glue(size)
    IOP.container("Rect", contents)
  end
end
