alias Chukinas.Util.{Maps, ById}

defmodule Maps do

  # TODO move this to a better-named module
  # TODO use this in the several places in sprite.ex
  def apply_to_each_val(%{} = map, fun) do
    map
    |> Stream.map(fn {key, val} -> {key, fun.(val)} end)
    |> Enum.into(%{})
  end

  def map_each(map, key, fun) do
    Map.update!(map, key, &Enum.map(&1, fun))
  end

  def put_by_id(map, key, item, id_key \\ :id) do
    Map.update!(map, key, &ById.put(&1, item, id_key))
  end
end
