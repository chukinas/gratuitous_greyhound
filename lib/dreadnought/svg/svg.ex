# TODO module name and file path don't match
defmodule Dreadnought.Svg do
  @moduledoc"""
  This module converts path structs to svg path strings for use in eex templates.
  """

  import Dreadnought.Util.Precision, only: [values_to_int: 1]
    use Dreadnought.Math
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  alias Dreadnought.Paths
  alias Dreadnought.Paths.Straight
  alias Dreadnought.Paths.Turn
  alias Dreadnought.Svg.PathDString

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
    #IO.warn "where called from"
    {start_x, start_y} = path |> Paths.pose_at_start |> vector_from_position
    {end_x, end_y} =
      path
      |> Paths.pose_at_end
      |> vector_from_position
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
    # TODO this function gets called waaayyy too much
  end

  def scale(svg_path, scale) when is_binary(svg_path) and is_integer(scale) do
    %{path: new_svg_path} = PathDString.interpret(svg_path, scale: scale)
    new_svg_path
  end

  def polygon_points_string_from_coords(coords) when is_list(coords) do
    coords
    |> Stream.map(&vector_to_comma_separated_string/1)
    |> Enum.join(" ")
  end

  def pose_to_attrs(%{x: x, y: y, angle: angle} = pose) when has_pose(pose) do
    [
      x: x,
      y: y,
      transform: "rotate(#{angle},#{x},#{y})"
    ]
  end

  def attrs_from_pose_and_opts(pose, opts \\ []) do
    Keyword.merge opts, pose_to_attrs(pose)
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

  # TODO replace is_number with is_vector?
  defp vector_to_comma_separated_string({x, y}) when is_number(x) and is_number(y) do
    "#{x},#{y}"
  end

  def render_polygon(points, opts \\ []) when is_list(opts) do
    Phoenix.HTML.Tag.content_tag(:polygon, nil,
      Keyword.put(opts, :points, polygon_points_string_from_coords(points))
    )
  end

  def render_use(href_id, opts \\ []) when is_list(opts) do
    attrs =
      opts
      |> Keyword.put(:href, "#" <> href_id)
    Phoenix.HTML.Tag.content_tag(:use, nil, attrs)
  end

  def render_use_with_pose(href_id, pose, opts \\ []) when has_pose(pose) and is_list(opts) do
    opts =
      opts
      |> Keyword.merge(pose |> pose_to_attrs)
    render_use(href_id, opts)
  end

  def render_image(href, opts \\ []) when is_list(opts) do
    attrs =
      opts
      |> Keyword.put(:href, href)
    Phoenix.HTML.Tag.content_tag(:image, nil, attrs)
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
