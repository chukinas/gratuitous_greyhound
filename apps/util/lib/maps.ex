alias Util.{Maps, IdList}

defmodule Maps do

  # TODO move this to a better-named module
  # TODO use this in the several places in sprite.ex
  def apply_to_each_val(%{} = map, fun) do
    map
    |> Stream.map(fn {key, val} -> {key, fun.(val)} end)
    |> Enum.into(%{})
  end

  # TODO be clearer about which funcs operate on lists

  def map_each(map, key, fun) do
    # TODO rename map_values
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

  def merge(map, pos_map, pos_module) do
    pos =
      pos_module
      |> apply(:new, [pos_map])
      |> Map.from_struct
    Map.merge(map, pos)
  end

  def merge!(struct, pos_map, pos_module) when is_struct(struct) do
    pos =
      pos_module
      |> apply(:new, [pos_map])
      |> Map.from_struct
    struct!(struct, pos)
  end

  @spec replace_keys(map, map, [atom]) :: map
  def replace_keys(to_struct, from_map, keys) when is_struct(to_struct) do
    fields = for key <- keys, do: {key, Map.fetch!(from_map, key)}
    struct!(to_struct, fields)
  end

  def replace_keys(to_map, from_map, keys) do
    Enum.reduce(keys, to_map, fn key, map ->
      val = Map.fetch!(from_map, key)
      Map.replace!(map, key, val)
    end)
  end

end
