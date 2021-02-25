alias Chukinas.Geometry.{Pose, Position}
defmodule Pose do

  import Position.Guard

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  # *** *******************************
  # *** NEW

  def new(position, angle) when has_position(position) do
    new(position.x, position.y, angle)
  end
  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: angle,
    }
  end

  # *** *******************************
  # *** NEW

  def origin(), do: new(0, 0, 0)
end
