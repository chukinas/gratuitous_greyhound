# TODO add docs
defmodule Chukinas.Dreadnought.Arrow do
  alias Chukinas.Dreadnought.Cartesian

  # *** *******************************
  # *** API
  
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
    # TODO change length to a module property
    path_len = 10
    "q 0 -#{path_len/2}, 4 -4"
  end

  # *** *******************************
  # *** HELPERS - HEAD

  defp build_svg_arrow_head(point, angle_deg) do
    tip = {0, -1.18}
    barb = {1, 0.42}
    # TODO replace above with actual values
    # TODO make a note in the docs that y points down
    # TODO is `points` a better term for x,y than `coordinates`?
    # TODO make a not that angle is relative to straight up. It's a command card value. point is a view/rendering value
    points = [
      {0, 0},
      barb,
      tip,
      Cartesian.mirror_y(barb)
    ]
    |> Cartesian.rotate_coordinate_list(angle_deg)
    |> Cartesian.translate_coordinate_list(point)
    |> to_space_separated_strings()
    "M #{points} z"
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
  
  # TODO run dialyxir.
  # TODO can I run dialyxir on every git commit?
end
