defmodule SunsCore.Space.TablePosition do

  use Spatial, :pos
  use CollisionDetection.CollidableImpl, :map_to_point

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :table_id, pos_integer
    field :x, number
    field :y, number
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(pos_integer, number, number) :: t
  def new(table_id, x, y) do
    %__MODULE__{
      table_id: table_id,
      x: x,
      y: y
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def table_id(%__MODULE__{table_id: value}), do: value

end
