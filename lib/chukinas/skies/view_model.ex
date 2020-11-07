defmodule Chukinas.Skies.ViewModel do
  alias Chukinas.Skies.Spaces

  def build(state) do
    %{
      spaces: render_spaces(state.spaces),
      bombers: render_bombers(state.elements)
    }
  end

  defp render_spaces(spaces) do
    {x_size, y_size} = Spaces.get_size(spaces)
    for y <- 0..y_size, do: render_row(spaces, y, x_size)
  end

  defp render_bombers(elements) do
    Enum.concat(elements)
  end

  defp render_row(spaces, y, max_x) do
    for x <- 0..max_x, do: {{x, y}, render_space(spaces, {x, y})}
  end

  defp render_space(spaces, coordinates) do
    Map.get(spaces, coordinates, ".")
  end

end
