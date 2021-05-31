alias Chukinas.Geometry.Straight
alias Chukinas.Paths
alias Chukinas.Paths.Turn
alias Chukinas.Svg.{Interpret}

defmodule Chukinas.Svg do
  @moduledoc"""
  This module converts path structs to svg path strings for use in eex templates.
  """

  import Chukinas.Util.Precision, only: [values_to_int: 1]
  import Chukinas.PositionOrientationSize
  use Chukinas.Math

  # *** *******************************
  # *** API

  @doc"""
  Convert a path struct to a svg path string that can be dropped into an eex template.
  """
  def get_path_string(%Straight{} = path) do
    {x0, y0} = get_start_coord(path)
    {x, y} = get_end_coord(path)
    "M #{x0} #{y0} L #{x} #{y}"
  end
  def get_path_string(%Turn{} = path) do
    {x0, y0} = get_start_coord(path)
    "M #{x0} #{y0} #{get_quadratic_curve(path)}"
  end

  def scale(svg_path, scale) when is_binary(svg_path) and is_integer(scale) do
    %{path: new_svg_path} = Interpret.interpret(svg_path, scale: scale)
    new_svg_path
  end

  # *** *******************************
  # *** PRIVATE

  defp get_start_coord(path) do
    path
    |> Paths.get_start_pose()
    |> values_to_int
    |> position_to_tuple
  end

  defp get_end_coord(path) do
    path
    |> Paths.get_end_pose()
    |> values_to_int
    |> position_to_tuple
  end

  # TODO I don't like calling the key directly her
  defp get_quadratic_curve(%Turn{traversal_angle: angle} = path)
  when angle <= 90 do
    radius = Turn.radius path
    half_angle_rad = abs(deg_to_rad(angle)) / 2
    length_to_intercept = radius * :math.tan(half_angle_rad)
    {dx, dy} =
      path
      |> Paths.get_start_pose()
      |> Paths.new_straight(length_to_intercept)
      |> Paths.get_end_pose()
      |> values_to_int
      |> position_to_tuple
    {x1, y1} = get_end_coord(path)
    "Q #{dx} #{dy} #{x1} #{y1}"
  end
  defp get_quadratic_curve(%Turn{} = path) do
    {right_angle_turn, remaining_turn} = Turn.split(path, 90)
    "#{get_quadratic_curve right_angle_turn} #{get_quadratic_curve remaining_turn}"
  end
end
