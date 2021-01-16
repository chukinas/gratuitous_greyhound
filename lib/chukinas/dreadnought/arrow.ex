defmodule Chukinas.Dreadnought.Arrow do
  @moduledoc """
  Generates the svg paths for movement arrow (shaft and head) on Dreadnought Command Cards
  """

  alias Chukinas.Dreadnought.Cartesian

  @arrow_length 10

  # *** *******************************
  # *** API
  
  @doc """
  Return map of svg paths for Command Card arrow head and shaft

  ## Examples
  
      iex> Chukinas.Dreadnought.Arrow.build_arrow_svg_paths(45)
      %{
        head: "M 4.0 4.0, 4.4 5.0, 4.8 3.2, 3.0 3.6 z",
        shaft: "m 3 10 q 0 -5.0, 4 -4"
      }
  """
  def build_arrow_svg_paths(angle_deg) do
    end_point = {4, 4}
    %{shaft: build_svg_arrow_shaft(angle_deg), head: build_svg_arrow_head(end_point, angle_deg)}
  end

  # *** *******************************
  # *** HELPERS - SHAFT
  
  defp build_svg_arrow_shaft(angle) do
    "m 3 10 #{build_svg_arrow_shaft_curve(angle)}"
  end

  defp build_svg_arrow_shaft_curve(_angle) do
    "q 0 -#{@arrow_length/2}, 4 -4"
  end

  # *** *******************************
  # *** HELPERS - HEAD

  defp build_svg_arrow_head(point, angle_deg) do
    tip = {0, -1.18}
    barb = {1, 0.42}
    points = [
      {0, 0},
      barb,
      tip,
      Cartesian.mirror_y(barb)
    ]
    |> Cartesian.rotate_coordinate_list(angle_deg)
    |> Cartesian.translate_coordinate_list(point)
    |> to_space_separated_strings()
    "M #{points} Z"
  end

  # *** *******************************
  # *** HELPERS

  def to_space_separated_strings(list_of_points) do
    list_of_points
    |> Enum.map(&point_to_space_separated_string/1)
    |> Enum.join(", ")
  end

  def point_to_space_separated_string({x, y}) do
    "#{_round(x)} #{_round(y)}"
  end

  def _round(number) when is_integer(number) do
    number
  end
  def _round(number) do
    Float.round(number, 1)
  end
  
end
