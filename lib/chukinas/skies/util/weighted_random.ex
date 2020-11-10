# https://www.nathanbuchar.com/weighted-random-elixir/
defmodule Chukinas.Skies.Util.WeightedRandom do

  @doc """
  Returns an anonymous function that when called will
  return a value from the given data set with a given
  weighted chance.
  """
  def new(data) do
    total_weight = Enum.reduce(data, 0, fn({w, _}, acc) -> w + acc end)

    fn ->
      target = :rand.uniform() * total_weight

      Enum.reduce_while data, target, fn({wgt, val}, acc) ->
        cond do
          acc - wgt > 0 ->
            {:cont, acc - wgt}
          true ->
            {:halt, val}
        end
      end
    end
  end
end
