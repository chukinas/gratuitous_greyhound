defmodule Chukinas.Skies.ViewModel do

  alias Chukinas.Skies.Game
  alias Chukinas.Skies.ViewModel.{
    Bombers,
    Boxes,
    Squadron,
    Spaces,
    TacticalPoints,
    TurnManager
  }

  defstruct [
    :squadron,
    :spaces,
    :bombers,
    :turn_manager,
    :escort_stations,
    :boxes,
  ]

  # *** *******************************
  # *** BUILD

  @spec build(Game.t()) :: any()
  def build(game) do
    vm_tp = TacticalPoints.build(game.tactical_points)
    %__MODULE__{
      squadron: Squadron.build(game.squadron, vm_tp),
      spaces: Spaces.build(game.spaces),
      bombers: Bombers.build(game.elements),
      turn_manager: TurnManager.build(game.turn, game.phase),
      escort_stations: %{},
      boxes: Boxes.build(game.boxes, game.squadron.groups),
    }
  end

end
