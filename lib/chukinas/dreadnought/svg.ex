# TODO can I rename this to SVG?
# TODO add docs
defmodule Chukinas.Dreadnought.Svg do
  import Chukinas.Dreadnought.Guards

  @decimal_count 1

  # *** *******************************
  # *** API

  def m_abs(point) when is_point(point) do
    "M #{point|> _to_string}"
  end

  def mz_abs(points) do
    "M #{points |> _to_string} Z"
  end

  def q_abs(quad_control, end_point) when is_point(quad_control) and is_point(end_point) do
    "Q #{[quad_control, end_point] |> _to_string}"
  end

  def relative_line(end_point) when is_point(end_point) do
    "l #{end_point |> _to_string}"
  end

  # *** *******************************
  # *** HELPERS

  defp _to_string(points) when is_list(points)do
    points
    |> Enum.map(&_to_string/1)
    |> Enum.join(", ")
  end

  defp _to_string({x, y} = point) when is_point(point) do
    "#{_round(x)} #{_round(y)}"
  end

  # TODO this has been moved to the Point module.
  # TODO or make this its own module?
  defp _round(number) when is_integer(number) do
    number
  end

  defp _round(number) when is_number(number) do
    Float.round(number, @decimal_count)
  end
end
