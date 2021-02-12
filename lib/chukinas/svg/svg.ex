alias Chukinas.Svg.ViewBox
alias Chukinas.Geometry.{Path, Position}
alias Chukinas.Geometry.Path.{Straight}

defmodule Chukinas.Svg do
  @moduledoc"""
  This module converts path structs to svg path strings for use in eex templates.
  """

  # *** *******************************
  # *** API

  defdelegate new_viewbox(path), to: ViewBox, as: :new

  @doc"""
  Convert a path struct to a svg path string that can be dropped into an eex template.
  """
  def to_string(%Straight{} = path) do
    {x, y} = path |> Path.get_end_pose() |> Position.to_tuple()
    "l #{x} #{y}"
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