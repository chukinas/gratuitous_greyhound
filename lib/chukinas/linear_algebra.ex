alias Chukinas.LinearAlgebra
alias Chukinas.LinearAlgebra.{CSys, Vector}

defmodule LinearAlgebra do

  use Chukinas.PositionOrientationSize
  require Vector.Guards

  def csys_from_pose(pose) when has_pose(pose) do
    CSys.new(pose)
  end

  def vector_new(element_with_csys, [x: x]) when is_number(x) do
    {x, 0}
    |> CSys.Conversion.convert_to_world_vector(element_with_csys)
  end

end
