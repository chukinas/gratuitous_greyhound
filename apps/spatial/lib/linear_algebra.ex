defmodule Spatial.LinearAlgebra do

  # TODO don't use `use`
  use Spatial.Math
  use Spatial.PositionOrientationSize
  use Spatial.LinearAlgebra.Csys.Guards
  alias Spatial.LinearAlgebra.Angle
  alias Spatial.LinearAlgebra.Csys
  alias Spatial.LinearAlgebra.Vector
  alias Spatial.LinearAlgebra.Vector.Guards
  require Guards

  # *** *******************************
  # *** USING

  defmacro __using__(_opts) do
    quote do
      require Spatial.LinearAlgebra
      import Spatial.LinearAlgebra
      import Spatial.LinearAlgebra.VectorApi
      import Spatial.LinearAlgebra.CsysApi
      import Spatial.LinearAlgebra.TransformApi
      use Spatial.LinearAlgebra.Csys.Guards
      use Spatial.LinearAlgebra.Vector.Guards
      @type vector :: {number, number}
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
