alias Chukinas.Geometry.{Trig}
alias Chukinas.LinearAlgebra.{Transform, Vector, Matrix, Token}

defmodule Token do

  use TypedStruct
  typedstruct enforce: true do
    field :__transforms__, [Transform.t()], default: []
  end

  def new, do: %__MODULE__{}
  def from(%__MODULE__{} = token, transform) do
    Map.update!(token, :transforms, & [Transform.flip(transform) | &1])
  end
  def to(%__MODULE__{} = token, transform) do
    Map.update!(token, :transforms, & [transform | &1])
  end

  #def exec(%__MODULE__{__transforms__: transforms}) do
  #  transforms
  #  |> Enum.reverse
  #  |> Enum.reduce(fn transform, acc ->

  #  end)
  #end
end

defmodule Transform do

  use TypedStruct
  typedstruct enforce: true do
    field :position, Vector.t()
    field :direction, Matrix.t()
  end

  # *** *******************************
  # *** NEW

  def new(%{x: x, y: y, angle: deg}) do
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

  #def apply(%__MODULE__{} = from, %__MODULE__{} = to) do
  #  trans.direction
  #  |> Matrix.mult(vector)
  #  |> Vector.add(trans.position)
  #end
end

defmodule Vector do
  @type t() :: {number(), number()}
  def flip({x, y}), do: {-x, -y}
  def dot({a, b}, {c, d}), do: a * c + b * d
  def add({a, b}, {c, d}), do: {a + c, b + d}
end

defmodule Matrix do
  @type t() :: {Vector.t(), Vector.t()}
  def flip({{a, b}, {c, d}}) do
    {{a, -b}, {-c, d}}
  end

  @spec mult(t(), Vector.t()) :: Vector.t()
  def mult({a, b}, c) do
    {Vector.dot(a, c), Vector.dot(b, c)}
  end
end

#defmodule LinearAlgebra.Rotation do
#
#  use TypedStruct
#  typedstruct enforce: true do
#    field :direction, number()
#    field :y, number()
#    field :width, number()
#    field :height, number()
#  end
#  def new(%{x: x, y: y, angle: deg}) do
#    {sin, cos} = Trig.sin_and_cos(deg)
#
#  end
#end
