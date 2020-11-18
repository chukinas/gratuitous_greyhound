defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.ViewModel.{Boxes, Squadron, Spaces, TurnManager}

  defstruct [
    :squadron,
    :spaces,
    :bombers,
    :boxes,
    :turn_manager,
    :escort_stations,
  ]

  # TODO rename 'build'
  def render(game) do
    %__MODULE__{
      squadron: Squadron.build(game.squadron),
      spaces: Spaces.render(game.spaces),
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
