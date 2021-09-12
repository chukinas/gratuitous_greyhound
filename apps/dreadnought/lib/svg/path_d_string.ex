defmodule Dreadnought.Svg.PathDString do
  @moduledoc"""
  Analyze output of Svg.Parse to determine e.g. min x and y..
  """

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
  alias Spatial.Geometry.Rect
  alias Dreadnought.Svg.Parse


  # TODO opts is the wrong word for this
  def interpret(svg, opts \\ []) when is_binary(svg) do
    svg
    |> Parse.parse(opts)
    |> _interpret()
  end

  defp _interpret(parsed_svg) when is_list(parsed_svg) do
    rect =
      parsed_svg
      |> to_positions
      |> position_min_max
      |> Rect.from_positions
    %{
      path: to_path(parsed_svg),
      rect: rect
    }
  end

  defp to_positions(cmds) do
    cmds
    |> Enum.map(&to_position/1)
    |> Enum.filter(& not is_nil &1)
  end

  # assumes absolute commands
  defp to_position(["Z"]), do: nil
  defp to_position([_, x, y]), do: position_new(x, y)

  defp to_path(cmds) do
    cmds
    |> Stream.concat
    |> Enum.join(" ")
  end

  # *** *******************************
  # *** CONVERTERS

  def to_coords(path_d_string) do
    path_d_string
    |> Parse.parse([])
    |> to_positions
    |> Enum.map(&vector_from_position/1)
  end

end
