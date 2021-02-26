alias Chukinas.Svg.ViewBox
alias Chukinas.Geometry.{Path, Position, Rect}
alias Chukinas.Geometry.Path.{Straight, Turn}

defmodule Chukinas.Svg do
  @moduledoc"""
  This module converts path structs to svg path strings for use in eex templates.
  """

  import Position.Guard

  # *** *******************************
  # *** API

  @doc"""
  Convert a path struct to a svg path string that can be dropped into an eex template.
  """
  def get_path_string(%Straight{} = path) do
    {x0, y0} = get_start_coord(path)
    # TODO x1 should just be x
    {x1, y1} = get_end_coord(path)
    "M #{x0} #{y0} L #{x1} #{y1}"
  end
  def get_path_string(%Turn{} = path) do
    {x0, y0} = get_start_coord(path)
    "M #{x0} #{y0} #{get_quadratic_curve(path)}"
  end

  def get_string(%Rect{} = bounding_rect, path_start_point, margin)
      when has_position(path_start_point)
      and is_number(margin) do
        ViewBox.to_viewbox_string(bounding_rect, path_start_point, margin)
  end

  # *** *******************************
  # *** API

  defp get_start_coord(path) do
    path
    |> Path.get_start_pose()
    |> Position.to_int_tuple()
  end

  defp get_end_coord(path) do
    path
    |> Path.get_end_pose()
    |> Position.to_int_tuple()
  end

  defp get_quadratic_curve(%Turn{angle: angle} = path) when abs(angle) <= 90 do
    radius = Turn.get_radius path
    half_angle_rad = Turn.get_angle_radians(path) / 2
    length_to_intercept = radius * :math.tan(half_angle_rad)
    {dx, dy} =
      path
      |> Path.get_start_pose()
      |> Path.new_straight(length_to_intercept)
      |> Path.get_end_pose()
      |> Position.to_int_tuple()
    {x1, y1} = get_end_coord(path)
    "Q #{dx} #{dy} #{x1} #{y1}"
  end
  # def m_abs(point) when is_point(point) do
  #   "M #{point|> _to_string}"
  # end

  # def mz_abs(points) do
  #   "M #{points |> _to_string} Z"
  # end

  # def q_abs(quad_control, end_point) when is_point(quad_control) and is_point(end_point) do
  #   "Q #{[quad_control, end_point] |> _to_string}"
  # end
end
