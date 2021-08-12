defmodule Dreadnought.PositionOrientationSize.PositionApi do

  alias Dreadnought.PositionOrientationSize.Position

  # *** *******************************
  # *** CONSTRUCTORS

  def position_origin, do: Position.new(0, 0)

  # *** *******************************
  # *** REDUCERS

  defdelegate position_multiply(position, scalar), to: Position, as: :multiply

  def position_flip(position), do: position |> position_multiply(-1)

  # *** *******************************
  # *** CONVERTERS

end
