alias Chukinas.Geometry.{Trig}
alias Chukinas.LinearAlgebra.{CSys, Vector, Matrix, HasCsys}

defmodule CSys do

  use TypedStruct
  typedstruct enforce: true do
    field :position, Vector.t()
    field :rotation, Matrix.t()
  end

  # *** *******************************
  # *** NEW

  def new(%{x: x, y: y, angle: deg}), do: new(x, y, deg)
  def new(%{x: x, y: y}), do: new(x, y, 0)
  def new({x, y}), do: new(x, y, 0)
  def new(x, y), do: new(x, y, 0)
  def new(x, y, deg) do
    {sin, cos} = Trig.sin_and_cos(deg)
    dir = {
      {cos, -sin},
      {sin,  cos}
    }
    %__MODULE__{
      position: {x, y},
      rotation: dir
    }
  end

  # *** *******************************
  # *** GETTERS

  def position(%__MODULE__{position: pos}), do: pos

  # *** *******************************
  # *** API

  # TODO rename reverse?
  def flip(%__MODULE__{rotation: dir, position: pos}) do
    matrix = Matrix.flip(dir)
    %__MODULE__{
      rotation: matrix,
      position: Matrix.mult(matrix, Vector.flip(pos))
    }
  end

  def transform(%__MODULE__{} = trans, vector) do
    trans.rotation
    |> Matrix.mult(vector)
    |> Vector.add(trans.position)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do
    def get_csys(self) do
      self
    end
  end
end
