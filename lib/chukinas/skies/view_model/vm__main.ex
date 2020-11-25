defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.Game
  alias Chukinas.Skies.ViewModel.{
    Bombers,
    Positions,
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
    :positions,
  ]

  # *** *******************************
  # *** BUILD

  @spec build(Game.t()) :: any()
  def build(game) do
    vm_tp = TacticalPoints.build(game.tactical_points)
    vm = %__MODULE__{
      squadron: Squadron.build(game.squadron, vm_tp),
      spaces: Spaces.build(game.spaces),
      bombers: Bombers.build(game.elements),
      turn_manager: TurnManager.build(game.turn_manager),
      escort_stations: %{},
      positions: Positions.build(game.boxes, game.squadron.groups),
    }
    # IO.inspect(vm.positions.not_entered, label: "not_entered")
    vm
  end

end
