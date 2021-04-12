alias Chukinas.Geometry.Position
alias Chukinas.Svg.{Interpret, Parse}

defmodule Interpret do
  @moduledoc"""
  Analyze output of Svg.Parse to determine e.g. min x and y..
  """

  def interpret(svg) when is_binary(svg) do
    svg
    |> Parse.parse
    |> interpret
  end
  def interpret(parsed_svg) when is_list(parsed_svg) do
    {min, max} =
      parsed_svg
      |> IOP.inspect("svg parsed")
      |> to_positions
      |> IOP.inspect("svg vertices")
      |> Position.min_max
      |> IOP.inspect("svg min max")
    %{
      path: to_path(parsed_svg),
      min: min,
      max: max,
      min_x: min.x,
      max_x: max.x,
      min_y: min.y,
      max_y: max.y
    }
  end

  defp to_positions(cmds) do
    cmds
    |> Enum.map(&to_position/1)
    |> Enum.filter(& not is_nil &1)
  end

  # assumes absolute commands
  defp to_position(["Z"]), do: nil
  defp to_position([_, x, y]), do: Position.new(x, y)

  defp to_path(cmds) do
    cmds
    |> Stream.concat
    |> Enum.join(" ")
  end
end
