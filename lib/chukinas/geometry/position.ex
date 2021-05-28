alias Chukinas.Geometry.{Position}
alias Chukinas.Util.Precision
alias Chukinas.PositionOrientationSize, as: POS

defmodule Position do
  import POS.Guards

  # TODO remove
  defguard is(position) when has_position(position)

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :x, number(), default: 0
    field :y, number(), default: 0
  end

  # *** *******************************
  # *** NEW

  def new(%{x: x, y: y}), do: new(x, y)
  def new({x, y}), do: new(x, y)
  def new(x, y) do
    %__MODULE__{
      x: x,
      y: y
    }
  end

  def rounded(%{x: x, y: y}), do: rounded(x, y)
  def rounded(x, y) do
    %__MODULE__{
      x: Precision.coerce_int(x),
      y: Precision.coerce_int(y)
    }
  end

  def from_size(%{width: x, height: y}), do: new(x, y)

  # *** *******************************
  # *** API

  def origin() do
    new(0, 0)
  end

  def to_tuple(%{x: x, y: y}), do: {x, y}

  def to_int_tuple(positionable), do: positionable |> round_to_int() |> to_tuple()

  def to_vertex(position) do
    position
    |> to_tuple
    |> Collision.Polygon.Vertex.from_tuple
  end

  def translate(positionable, addend) when has_position(positionable) do
    addend_map = addend |> sanitize_translation()
    positionable
    |> Map.put(:x, positionable.x + addend_map.x)
    |> Map.put(:y, positionable.y + addend_map.y)
  end

  def add(augend, addend), do: translate(augend, addend)
  def add(augend, x, y), do: translate(augend, {x, y})

  def add_x(position, %{x: dx}), do: add position, dx, 0
  def add_x(position, dx), do: add position, dx, 0

  def add_y(position, %{y: dy}), do: add position, 0, dy
  def add_y(position, dy), do: add position, 0, dy

  def subtract(position, x, y), do: translate(position, {-x, -y})
  def subtract(position, number) when is_number(number) do
    subtract(position, number, number)
  end
  def subtract(position, translation) do
    translate(position, {-translation.x, -translation.y})
  end

  def multiply(position, value) do
    fun = &(&1 * value)
    position
    |> Map.update!(:x, fun)
    |> Map.update!(:y, fun)
  end

  def divide(position, value) when not (value == 0), do: multiply(position, 1/value)

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
    position |> Map.take([:x, :y])
  end

  def approx_equal(a, b) do
    Precision.approx_equal(a.x, b.x) and Precision.approx_equal(a.y, b.y)
  end

  def shake(position, radius \\ 100) do
    range = -radius..radius
    add position, Enum.random(range), Enum.random(range)
  end

  def change_coord_sys(position, before_relative_to \\ Position.origin(), after_relative_to) do
    position
    |> Position.subtract(before_relative_to)
    |> Position.add(after_relative_to)
  end

  # *** *******************************
  # *** LIST API

  def min_max(positions) when is_list(positions) do
    {xmin, xmax} = Enum.min_max_by(positions, & &1.x)
    {ymin, ymax} = Enum.min_max_by(positions, & &1.y)
    {Position.new(xmin.x, ymin.y), Position.new(xmax.x, ymax.y)}
  end

  # *** *******************************
  # *** PRIVATE

  defp sanitize_translation(value) when has_position(value), do: Map.take(value, [:x, :y])
  defp sanitize_translation(value) when is_number(value), do: %{x: value, y: value}
  defp sanitize_translation({x, y}), do: %{x: x, y: y}


  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    require IOP
    def inspect(position, opts) do
      {x, y} = {round(position.x), round(position.y)}
      concat [
        IOP.color("#Position<"),
        IOP.doc(x),
        ", ",
        IOP.doc(y),
        IOP.color(">")
      ]
    end
  end
end
