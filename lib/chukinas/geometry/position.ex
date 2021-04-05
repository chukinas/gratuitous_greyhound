alias Chukinas.Geometry.{Position}
alias Chukinas.Util.Precision

defmodule Position do
  import Position.Guard

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
    %__MODULE__{x: x, y: y}
  end

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

  # *** *******************************
  # *** PRIVATE

  defp sanitize_translation(value) when has_position(value), do: Map.take(value, [:x, :y])
  defp sanitize_translation(value) when is_number(value), do: %{x: value, y: value}
  defp sanitize_translation({x, y}), do: %{x: x, y: y}


  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    def inspect(position, _opts) do
      "#Position<#{round position.x}, #{round position.y}>"
    end
  end
end
