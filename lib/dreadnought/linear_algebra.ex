defmodule Dreadnought.LinearAlgebra do

  # TODO don't use `use`
  use Dreadnought.Math
  use Dreadnought.PositionOrientationSize
  use Dreadnought.LinearAlgebra.Csys.Guards
  alias Dreadnought.LinearAlgebra.Angle
  alias Dreadnought.LinearAlgebra.Csys
  alias Dreadnought.LinearAlgebra.Vector
  alias Dreadnought.LinearAlgebra.Vector.Guards
  require Guards

  # *** *******************************
  # *** USING

  defmacro __using__(_opts) do
    quote do
      require Dreadnought.LinearAlgebra
      import Dreadnought.LinearAlgebra
      import Dreadnought.LinearAlgebra.VectorApi
      import Dreadnought.LinearAlgebra.CsysApi
      import Dreadnought.LinearAlgebra.TransformApi
      use Dreadnought.LinearAlgebra.Csys.Guards
      use Dreadnought.LinearAlgebra.Vector.Guards
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
