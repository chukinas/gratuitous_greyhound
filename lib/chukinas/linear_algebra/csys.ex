# TODO where is this used? Has VectorCsys fully superseded it?
alias Chukinas.LinearAlgebra.{CSys, Vector, Matrix, HasCsys}

defmodule CSys do

  use Chukinas.Math

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
    {sin, cos} = sin_and_cos(deg)
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
  def angle(%__MODULE__{} = csys) do
    csys
    |> sin_and_cos_from_orientation
    |> Vector.from_sin_and_cos
    |> Vector.angle
  end

  def sin_and_cos_from_orientation(%__MODULE__{rotation: rotation}) do
    elem(rotation, 1)
  end

  # *** *******************************
  # *** SETTERS

  def put_position(%__MODULE__{position: pos}), do: pos

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

  def strip_out_rotation(%__MODULE__{position: position}) do
    new(position)
  end

  def strip_out_position(csys) do
    %__MODULE__{csys | position: Vector.origin()}
  end

  def transform(%__MODULE__{} = trans, vector) do
    trans.rotation
    |> Matrix.mult(vector)
    |> Vector.sum(trans.position)
  end

  def translate(%__MODULE__{} = trans, vector) do
    trans.rotation
    |> Matrix.mult(vector)
    |> Vector.sum(trans.position)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasCsys do
    def get_csys(self) do
      self
    end
    def get_angle(self) do
      CSys.angle(self)
    end
  end
end
