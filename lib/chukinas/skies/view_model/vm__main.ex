defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.ViewModel.{Boxes, Spaces}

  def render(state) do
    %{
      spaces: Spaces.render(state.spaces),
      bombers: render_bombers(state.elements),
      boxes: Boxes.render(state.boxes),
      turn: %{
        current: 2,
        max: 8
      },
    }
  end

  defp render_bombers(elements) do
    Enum.concat(elements)
  end

end
