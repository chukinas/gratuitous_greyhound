defmodule Chukinas.Util.Precision do

  def coerce_number!(val) when is_number(val), do: val
  def coerce_number!(val) when is_binary(val) do
    {float, _} = Float.parse(val)
    float
  end

  def coerce_int(val) when is_list(val), do: Enum.map(val, &coerce_int/1)
  def coerce_int(val) when is_integer(val), do: val
  def coerce_int(val) when is_float(val), do: round(val)
  def coerce_int(val) when is_binary(val) do
    {float, _} = Float.parse(val)
    round float
  end

  def values_to_int({key, value}) when is_map(value), do: {key, values_to_int(value)}
  def values_to_int({key, value}) when is_number(value), do: {key, round(value)}
  def values_to_int(struct) when is_struct(struct) do
    rounded_map = struct |> Map.from_struct() |> values_to_int()
    struct |> Map.merge(rounded_map)
  end
  def values_to_int(map) when is_map(map) do
    keys = map |> Map.keys()
    values_to_int(map, keys)
  end

  def values_to_int(map, keys) do
    map_overrides = map |> Map.take(keys) |> Enum.map(&values_to_int/1) |> Map.new()
    map |> Map.merge(map_overrides)
  end

  def approx_equal(a, b) do
    abs(a - b) < 1
  end

  def approx_equal(a, b, key) do
    approx_equal(
      Map.fetch!(a, key),
      Map.fetch!(b, key)
    )
  end

end
