defmodule DreadnoughtHelpers do
  defmacro __using__(_options) do
    quote do
      alias Chukinas.Geometry.Path
      alias Chukinas.Svg
      import DreadnoughtHelpers, only: :functions
    end
  end

  def match_numerical_map?(expected, actual) do
    expected = expected |> set_precision()
    actual = Map.take(actual, Map.keys(expected)) |> set_precision()
    Map.equal?(expected, actual)
  end

  defp set_precision(%{} = map) do
    map
    # TODO is the 'to list' necessary?
    # TODO vim remove the underline. It's getting distracting
    |> Map.to_list()
    |> Enum.map(&set_precision/1)
    |> Map.new()
  end

  defp set_precision({key, value}) do
    {key, set_precision(value)}
  end

  defp set_precision(value) when is_float(value) do
    Float.round(value, 1)
  end

  defp set_precision(value) when is_integer(value) do
    value * 1.0
  end
end
