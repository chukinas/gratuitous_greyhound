alias Chukinas.Util.{Maps, IdList}

defmodule Maps do

  # TODO move this to a better-named module
  # TODO use this in the several places in sprite.ex
  def apply_to_each_val(%{} = map, fun) do
    map
    |> Stream.map(fn {key, val} -> {key, fun.(val)} end)
    |> Enum.into(%{})
  end

  # TODO be clearer about which funcs operate on lists

  # TODO rename map_values
  def map_each(map, key, fun) do
    Map.update!(map, key, &Enum.map(&1, fun))
  end

  def put_by_id(map, key, item, id_key \\ :id) do
    Map.update!(map, key, &IdList.put(&1, item, id_key))
  end

  def push(map, key, items) when is_list(items) do
    Map.update!(map, key, & items ++ &1)
  end
  def push(map, key, item) do
    Map.update!(map, key, &[item | &1])
  end

  def clear(map, key), do: Map.update!(map, key, &__clear__/1)
  defp __clear__(value) when is_list(value), do: []
end
