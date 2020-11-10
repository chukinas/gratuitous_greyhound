defmodule Chukinas.Skies.Game.Collision do
  alias Chukinas.Skies.Util.WeightedRandom

  def draw_rand_token do
    randomizer = WeightedRandom.new(spec)
    randomizer.()
  end

  defp spec do
    [
      {15, :no_collision},
      {4, {:escape, 1}},
      {4, {:escape, 2}},
      {5,  :veer},
      {4,  :hit},
      {1, {:maybe_impact, 3}},
      {7, {:maybe_impact, 2}},
    ]
  end

end
