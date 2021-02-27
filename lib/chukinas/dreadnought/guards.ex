defmodule Chukinas.Dreadnought.Guards do
  defguard is_point(point)
    when is_tuple(point)
    and tuple_size(point) == 2
    and is_number(elem(point, 0))
    and is_number(elem(point, 1))

  # TODO either rename this module or move this function to new/other mod
  def get_by_id(enum, id) do
    default = "No id of #{id} found in #{enum}."
    Enum.find enum, default, fn item -> id_matches?(item, id) end
  end

  defp id_matches?(%{id: id}, sought_id), do: id == sought_id
end
