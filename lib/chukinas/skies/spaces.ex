defmodule Chukinas.Skies.Spaces do

  def build_map_spec() do
    [
      {{0, 0}, 5}, {{1, 0}, 4}, {{2, 0}, 1}, {{3, 0}, 10},
      {{0, 1}, 5}, {{1, 1}, 4}, {{2, 1}, 1}, {{3, 1}, 10},
      {{0, 2}, 5}, {{1, 2}, 4}, {{2, 2}, 1}, {{3, 2}, 10},
      {{0, 3}, 5}, {{1, 3}, 4}, {{2, 3}, 1}, {{3, 3}, 10},
    ]
  end

  def render_spaces() do
    for y <- 0..5, do: render_row(:nothing, y, 3)
  end

  def render_row(_spaces, y, max_x) do
    for x <- 0..max_x, do: {{x, y}, "bye"}
  end

  def get_size(spaces) do
    {
      get_single_dimension(spaces, &get_x/1),
      get_single_dimension(spaces, &get_y/1)
    }
  end

  defp get_single_dimension(spaces, getter) do
    max_space = Enum.max_by(spaces, fn space -> getter.(space) end)
    getter.(max_space)
  end

  def get_x({{x, _}, _}) do
    x
  end

  def get_y({{_, y}, _}) do
    y
  end

  def get_number({_, val}) do
    val
  end

end
