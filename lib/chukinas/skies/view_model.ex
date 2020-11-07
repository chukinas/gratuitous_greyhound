defmodule Chukinas.Skies.ViewModel do

  def build(state) do
    %{
      spaces: render_spaces(state.spaces),
      bombers: render_bombers(state.elements)
    }
  end

  defp render_spaces(spaces) do
    spaces
    |> Map.to_list()
    |> Enum.map(&render_space/1)
  end

  defp render_bombers(elements) do
    Enum.concat(elements)
  end

  defp render_space({{x, y}, content}) do
    %{x: x, y: y, lethal_level: content}
  end

end
