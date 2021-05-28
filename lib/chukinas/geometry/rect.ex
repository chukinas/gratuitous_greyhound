alias Chukinas.Geometry.{Rect, CollidableShape}

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
    new(
      position_new(start_x, start_y),
      position_new(end_x, end_y)
    )
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
  when has_position(start_position)
  and has_position(end_position) do
    size = size_from_positions(start_position, end_position)
    fields =
      %{}
      |> merge_position(start_position)
      |> merge_size(size)
    struct!(__MODULE__, fields)
  end

  def new(width, height)
  when is_number(width)
  and is_number(height) do
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
  def bottom_right_position(rect) do
    rect
    |> position_from_size
    |> position_add(rect)
  end

  def list_vertices(rect) do
    # TODO rename vertices
    # TODO move getters to appropriate section
    position_top_left = position(rect)
    relative_position_br = rect |> position_from_size
    for pos <- [
      position_top_left,
      position_add_x(position_top_left, relative_position_br),
      bottom_right_position(rect),
      position_add_y(position_top_left, relative_position_br)
    ], do: position_to_vertex(pos)
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
    {min, max} = position_min_max(list)
    new(min, max)
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
      pos = rect |> position_new |> IOP.doc
      size = rect |> size_new |> IOP.doc
      contents =
        pos
        |> concat(IOP.comma)
        |> glue(size)
      IOP.container("Rect", contents)
    end
  end
end
