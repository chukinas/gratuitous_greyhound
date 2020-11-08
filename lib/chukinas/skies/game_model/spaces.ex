defmodule Chukinas.Skies.Spaces do

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
