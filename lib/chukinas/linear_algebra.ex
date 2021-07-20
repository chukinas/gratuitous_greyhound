defmodule Chukinas.LinearAlgebra do

  # TODO don't use `use`
  use Chukinas.Math
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Csys.Guards
  alias Chukinas.LinearAlgebra.Angle
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.Vector.Guards
  require Guards

  # *** *******************************
  # *** USING

  defmacro __using__(_opts) do
    quote do
      require Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra.VectorApi
      import Chukinas.LinearAlgebra.CsysApi
      import Chukinas.LinearAlgebra.TransformApi
      use Chukinas.LinearAlgebra.Csys.Guards
      use Chukinas.LinearAlgebra.Vector.Guards
    end
  end


  # *** *******************************
  # *** MACROS

  use TypedStruct

  defmacro csys_fields do
    quote do
      field :orientation, Vector.t, enforce: true
      field :location, Vector.t, enforce: true
    end
  end

  # *** *******************************
  # *** MERGE

  def merge_csys(map, csys_map) do
    %Csys{orientation: orient, location: coord} = Csys.from_map(csys_map)
    map
    |> Map.put(:orientation, orient)
    |> Map.put(:location, coord)
  end

  # *** *******************************
  # *** ANGLE

  def angle_relative_to_vector(to_vector, from_vector) do
    Angle.from_vector(to_vector, from_vector)
  end

  def angle_between_vectors(a, b), do: Angle.between_vectors(a, b)

end
