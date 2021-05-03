alias Chukinas.Geometry.{Trig}
alias Chukinas.LinearAlgebra.{CSys, Vector, Matrix}

defmodule CSys do

  use TypedStruct
  typedstruct enforce: true do
    field :position, Vector.t()
    # TODO rename rotation?
    field :direction, Matrix.t()
  end

  # *** *******************************
  # *** NEW

  def new(%{x: x, y: y, angle: deg}), do: new(x, y, deg)
  def new(%{x: x, y: y}), do: new(x, y)
  def new(x, y) do
    %__MODULE__{
      position: {x, y},
      direction: Matrix.identity()
    }
  end
  def new(x, y, deg) do
    {sin, cos} = Trig.sin_and_cos(deg)
    dir = {
      {cos, -sin},
      {sin,  cos}
    }
    %__MODULE__{
      position: {x, y},
      direction: dir
    }
  end

  # *** *******************************
  # *** GETTERS

  def position(%__MODULE__{position: pos}), do: pos

  # *** *******************************
  # *** API

  # TODO rename reverse?
  def flip(%__MODULE__{direction: dir, position: pos}) do
    matrix = Matrix.flip(dir)
    %__MODULE__{
      direction: matrix,
      position: Matrix.mult(matrix, Vector.flip(pos))
    }
  end

  def transform(%__MODULE__{} = trans, vector) do
    trans.direction
    |> Matrix.mult(vector)
    |> Vector.add(trans.position)
  end
end
