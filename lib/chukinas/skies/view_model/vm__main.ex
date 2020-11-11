defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.ViewModel.{Boxes, Spaces, TurnManager}

  def render(game) do
    %{
      spaces: Spaces.render(game.spaces),
      bombers: render_bombers(game.elements),
      boxes: Boxes.render(game.boxes),
      turn_manager: TurnManager.render(game.turn_manager)
    }
  end

  defp render_bombers(elements) do
    Enum.concat(elements)
  end

end
