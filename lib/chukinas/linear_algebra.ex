alias Chukinas.LinearAlgebra
alias Chukinas.LinearAlgebra.{CSys, Vector}

defmodule LinearAlgebra do

  use Chukinas.PositionOrientationSize
  require Vector.Guards
  import CSys.Conversion

  def csys_from_pose(pose) when has_pose(pose) do
    CSys.new(pose)
  end

  def vector_forward(item, distance) when has_pose(item) do
    convert_to_world_vector({distance, 0}, item)
  end

  def vector_left(item, distance) when has_pose(item) do
    convert_to_world_vector({0, -distance}, item)
  end

  def vector_right(item, distance) when has_pose(item) do
    convert_to_world_vector({0, +distance}, item)
  end

end
