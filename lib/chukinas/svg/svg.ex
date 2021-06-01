alias Chukinas.Geometry.Straight
alias Chukinas.Paths
alias Chukinas.Paths.Turn
alias Chukinas.Svg.{Interpret}
alias Chukinas.LinearAlgebra

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
    IO.warn "where called from"
    {start_x, start_y} = path |> Paths.pose_at_start |> LinearAlgebra.coord_from_position
    {end_x, end_y} = path |> Paths.pose_at_end |> LinearAlgebra.coord_from_position
    rx = ry = _radius = path |> Paths.radius
    large_arc_flag = if Paths.traversal_angle(path) > 180, do: 1, else: 0
    sweep_flag =
      case Paths.rotation_direction(path) do
        :cw  -> 1
        :ccw -> 0
      end
    [
      "M", start_x, start_y,
      "A", rx, ry, 0, large_arc_flag, sweep_flag, end_x, end_y
    ]
    |> Stream.map(&round_number/1)
    |> Enum.join(" ")
    |> IOP.inspect("svg turn")
    # TODO this function gets called waaayyy too much
  end

  def scale(svg_path, scale) when is_binary(svg_path) and is_integer(scale) do
    %{path: new_svg_path} = Interpret.interpret(svg_path, scale: scale)
    new_svg_path
  end

  # *** *******************************
  # *** PRIVATE

  defp round_number(string) when is_binary(string), do: string
  defp round_number(number), do: round(number)

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
  #defp get_quadratic_curve(%Turn{traversal_angle: angle} = path)
  #when angle <= 90 do
  #  radius = Turn.radius path
  #  half_angle_rad = abs(deg_to_rad(angle)) / 2
  #  length_to_intercept = radius * :math.tan(half_angle_rad)
  #  {dx, dy} =
  #    path
  #    |> Paths.get_start_pose()
  #    |> Paths.new_straight(length_to_intercept)
  #    |> Paths.get_end_pose()
  #    |> values_to_int
  #    |> position_to_tuple
  #  {x1, y1} = get_end_coord(path)
  #  "Q #{dx} #{dy} #{x1} #{y1}"
  #end
  #defp get_quadratic_curve(%Turn{} = path) do
  #  {right_angle_turn, remaining_turn} = Turn.split(path, 90)
  #  "#{get_quadratic_curve right_angle_turn} #{get_quadratic_curve remaining_turn}"
  #end
end
