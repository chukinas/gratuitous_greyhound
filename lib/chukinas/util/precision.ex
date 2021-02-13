defmodule Chukinas.Util.Precision do

  def values_to_int(map, keys) do
    map_overrides = map |> Map.take(keys) |> Enum.map(&value_to_int/1) |> Map.new()
    map |> Map.merge(map_overrides)
  end

  defp value_to_int({key, value}), do: {key, round(value)}

end
