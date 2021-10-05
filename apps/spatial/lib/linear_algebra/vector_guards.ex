defmodule Spatial.LinearAlgebra.Vector.Guards do

  defmacro __using__(_opts) do
    quote do
      require Spatial.LinearAlgebra.Vector.Guards
      import Spatial.LinearAlgebra.Vector.Guards
    end
  end

  defguard is_vector(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_number
    and elem(value, 1) |> is_number

end
