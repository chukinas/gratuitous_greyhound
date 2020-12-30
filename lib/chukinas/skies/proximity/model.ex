defmodule Chukinas.Skies.Game.Proximity do

  # FIX rename Collision?

  def rand() do
    Enum.random([
      :no_collision,
      {:escape, Enum.random(1..3)},
      :veer,
      :hit,
      {:maybe_impact, Enum.random(1..3)},
    ])
  end

end
