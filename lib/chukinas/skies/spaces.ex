defmodule Chukinas.Skies.Spaces do

  def get_formation({1, "a"}) do
    %{
                   {1, 0} => 1, {2, 0} => 1, {3, 0} => 1,
      {0, 1} => 1, {1, 1} => 1, {2, 1} => 2, {3, 1} => 1,
      {0, 2} => 1, {1, 2} => 2, {2, 2} => 3, {3, 2} => 1,
      {0, 3} => 1, {1, 3} => 2, {2, 3} => 2, {3, 3} => 1,
      {0, 4} => 1, {1, 4} => 1, {2, 4} => 1, {3, 4} => 1,
    }
  end

  def get_formation({1, "b"}) do
    %{
      {0, 0} => 1, {1, 0} => 1, {2, 0} => 1, {3, 0} => 1,
      {0, 1} => 1, {1, 1} => 2, {2, 1} => 2, {3, 1} => 1,
      {0, 2} => 1, {1, 2} => 2, {2, 2} => 2, {3, 2} => 1,
      {0, 3} => 1, {1, 3} => 2, {2, 3} => 2, {3, 3} => 1,
      {0, 4} => 1, {1, 4} => 2, {2, 4} => 2, {3, 4} => 1,
      {0, 5} => 1, {1, 5} => 1, {2, 5} => 1, {3, 5} => 1,
    }
  end

  def render_grid(spaces) do
    {x_size, y_size} = get_size(spaces)
    for y <- 0..y_size, do: render_row(spaces, y, x_size)
  end

  def render_row(spaces, y, max_x) do
    for x <- 0..max_x, do: {{x, y}, render_space(spaces, {x, y})}
  end

  def render_space(spaces, coordinates) do
    Map.get(spaces, coordinates, ".")
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
