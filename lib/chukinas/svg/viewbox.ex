alias Chukinas.Svg.ViewBox
alias Chukinas.Geometry.{Path, Rect, Position}
alias Chukinas.Util.Precision

defmodule ViewBox do
  require Position

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # This rect is relative to the start point of the path
    field :relative_rect, Rect.t()
    field :margin, number(), default: 10
  end

  # *** *******************************
  # *** NEW

  @spec new(Path.t()) :: t()
  def new(path) do
    start_position = path |> Path.get_start_pose()
    %__MODULE__{
      relative_rect: path |> Path.get_bounding_rect() |> Rect.subtract(start_position)
    }
  end

  # *** *******************************
  # *** API

  def to_viewbox_string(%Rect{} = bounding_rect, path_start_point, margin)
      when Position.is(path_start_point)
      and is_number(margin) do
        relative_rect_with_margin = bounding_rect
                                    |> Rect.subtract(path_start_point)
                                |> Rect.apply_margin(margin)
        position = relative_rect_with_margin |> Rect.get_start_position() |> Precision.values_to_int()
        size = Rect.get_size(relative_rect_with_margin)
        "#{position.x} #{position.y} #{round(size.width)} #{size.height |> round()}"
  end

end
