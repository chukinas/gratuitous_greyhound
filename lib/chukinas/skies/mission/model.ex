defmodule Chukinas.Skies.Game.Mission do

  def set_up() do
    %{
      year: 1942,
      type: :outbound,
      operations_points: 6,
      escort: %{
        enter_on_turn: 5,
        weigh: :light,
        type: :spitfire
      },
    }
  end

end
