alias Chukinas.Geometry.{Grid}

defmodule Grid do
  @moduledoc"""
  Represents the square chess-like board the game is played on
  """

  use TypedStruct

  typedstruct enforce: true do
    field :square_size, integer()
    field :x_count, integer()
    field :y_count, integer()
    field :width, integer()
    field :height, integer()
  end

  # *** *******************************
  # *** NEW

  def new(square_size, x_count, y_count) do
    %__MODULE__{
      square_size: square_size,
      x_count: x_count,
      y_count: y_count,
      width: square_size * x_count,
      height: square_size * y_count
    }
  end

  # *** *******************************
  # *** API

  def size(grid) do
    %{
      width: grid.square_size * grid.x_count,
      height: grid.square_size * grid.y_count
    }
  end

end
