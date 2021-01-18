defmodule Chukinas.Dreadnought.Guards do
  defguard is_point(point)
    when is_tuple(point)
    and tuple_size(point) == 2
    and is_number(elem(point, 0))
    and is_number(elem(point, 1))
end
