defmodule Chukinas.Skies.ViewModel.Spaces do

  def render(spaces) do
    spaces
    |> Map.to_list()
    |> Enum.map(&render_space/1)
  end

  defp render_space({{x, y}, content}) do
    %{x: x, y: y, lethal_level: content}
  end

end
