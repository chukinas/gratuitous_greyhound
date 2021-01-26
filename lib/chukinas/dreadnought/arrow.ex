defmodule Chukinas.Dreadnought.Arrow do
  @moduledoc """
  Generate svg paths for movement arrow (shaft and head) on Dreadnought Command Cards
  """

  alias Chukinas.Dreadnought.Point
  alias Chukinas.Dreadnought.Vector
  alias Chukinas.Dreadnought.Svg

  @arrow_length 7
  @arrow_start_y 9
  @arrow_center_x 7

  # *** *******************************
  # *** API

  @doc """
  Return map of svg paths for Command Card arrow head and shaft

  ## Examples

      iex> Chukinas.Dreadnought.Arrow.build_arrow_svg_paths(90)
      %{
        head: "M 8.6 4.5, 8.2 5.5, 9.8 4.5, 8.2 3.5 Z",
        shaft: "M 4.2 9 Q 4.2 4.5, 8.6 4.5"
      }
  """
  def build_arrow_svg_paths(angle_deg) do
    start_vector = Vector.new(0, 0, -90)
    end_vector = Vector.move_along_arc(start_vector, @arrow_length, angle_deg)
    head_points = get_arrow_head_points()
    |> Vector.move_with_vector(start_vector, end_vector)
    points = %{
      shaft_start: start_vector.point,
      shaft_end: end_vector.point,
      shaft_quad_control: Vector.get_y_intercept(end_vector),
    }
    |> Map.merge(head_points)
    |> center_on_y_axis()
    |> Point.translate({@arrow_center_x, @arrow_start_y})
    %{
      shaft: build_svg_arrow_shaft(points),
      head: build_svg_arrow_head(points)
    }
  end

  # *** *******************************
  # *** HELPERS

  defp get_arrow_head_points() do
    barb = {1, 0.42}
    %{
      tip: {0, -1.18},
      barb_right: barb,
      barb_left: Point.mirror_y barb
    }
  end

  defp center_on_y_axis(points) do
    {min, max} = points
    |> Map.values()
    # TODO can this be a Stream?
    |> Enum.map(fn {x, _y} -> x end)
    |> Enum.min_max()
    points
    |> Point.translate({(min - max) / 2, 0})
  end

  defp build_svg_arrow_shaft(points) do
    [
      points.shaft_start |> Svg.m_abs(),
      Svg.q_abs(points.shaft_quad_control, points.shaft_end)
    ]
    |> Enum.join(" ")
  end

  defp build_svg_arrow_head(points) do
    [
      :shaft_end,
      :barb_right,
      :tip,
      :barb_left,
    ]
    |> Enum.map(fn key -> Map.get(points, key) end)
    |> Svg.mz_abs()
  end

end
