# TODO add docs
defmodule Chukinas.Svg do
  alias Chukinas.Svg.ViewBox
  # TODO used?
  # @decimal_count 1

  # *** *******************************
  # *** API

  defdelegate new_viewbox(path), to: ViewBox, as: :new

  def to_string(_path) do
    "This is just a placeholder. It'll soon return something like `l 10 24`"
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

  # *** *******************************
  # *** HELPERS

  # defp _to_string(points) when is_list(points)do
  #   points
  #   |> Enum.map(&_to_string/1)
  #   |> Enum.join(", ")
  # end

  # defp _to_string({x, y} = point) when is_point(point) do
  #   "#{_round(x)} #{_round(y)}"
  # end

  # # TODO this has been moved to the Point module.
  # # TODO or make this its own module?
  # defp _round(number) when is_integer(number) do
  #   number
  # end

  # defp _round(number) when is_number(number) do
  #   Float.round(number, @decimal_count)
  # end
end
