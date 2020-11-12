defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.ViewModel.{Boxes, Spaces, TurnManager}

  def render(game) do
    %{
      pilots: %{},
      spaces: Spaces.render(game.spaces),
      bombers: render_bombers(game.elements),
      boxes: Boxes.render(game.boxes),
      turn_manager: TurnManager.build(game.turn_manager),
      escort_stations: %{},
    }
  end

  defp render_bombers(elements) do
    Enum.concat(elements)
  end

end
