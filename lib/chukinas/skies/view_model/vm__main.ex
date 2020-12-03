defmodule Chukinas.Skies.ViewModel do

  alias Chukinas.Skies.Game
  alias Chukinas.Skies.ViewModel.{
    Bombers,
    Boxes,
    EscortStations,
    Squadron,
    Spaces,
    TacticalPoints,
    TurnManager
  }

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :squadron, Squadron.t()
    field :spaces, Spaces.t()
    field :bombers, Bombers.t()
    field :turn_manager, TurnManager.t()
    field :escort_stations, EscortStations.t()
    field :boxes, Boxes.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build(Game.t()) :: t()
  def build(game) do
    vm_tp = TacticalPoints.build(game.tactical_points)
    %__MODULE__{
      squadron: Squadron.build(game.squadron, vm_tp),
      spaces: Spaces.build(game.spaces),
      bombers: Bombers.build(game.bombers),
      turn_manager: TurnManager.build(game.turn, game.phase),
      escort_stations: EscortStations.build(game.escorts),
      boxes: Boxes.build(game.boxes, game.squadron.groups),
    }
  end

end
