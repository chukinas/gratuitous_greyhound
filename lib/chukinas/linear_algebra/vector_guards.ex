defmodule Chukinas.LinearAlgebra.Vector.Guards do
  defguard is_vector(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_number
    and elem(value, 1) |> is_number
end
