defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.Game
  alias Chukinas.Skies.ViewModel.{Boxes, Squadron, Spaces, TacticalPoints, TurnManager}

  defstruct [
    :squadron,
    :spaces,
    :bombers,
    :boxes,
    :turn_manager,
    :escort_stations,
  ]

  @spec build(Game.t()) :: any()
  def build(game) do
    vm_tp = TacticalPoints.build(game.tactical_points)
    %__MODULE__{
      squadron: Squadron.build(game.squadron, vm_tp),
      spaces: Spaces.build(game.spaces),
      bombers: render_bombers(game.elements),
      boxes: Boxes.render(game.boxes),
      turn_manager: TurnManager.build(game.turn_manager),
      escort_stations: %{},
    }
  end

  # TODO move this elsewhere
  defp render_bombers(elements) do
    Enum.concat(elements)
  end

end
