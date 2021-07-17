defmodule ChukinasWeb.Shared do

  alias ChukinasWeb.DreadnoughtPlayView
  use Chukinas.PositionOrientationSize

  def top_left_width_height_from_rect(rect) do
    # TODO extract all these methods into this module
    DreadnoughtPlayView.render_rect_as_style_attrs(rect)
  end

  def left_top_from_position(position) do
    DreadnoughtPlayView.left_top_from_position position
  end

  def width_height_from_size(size) do
    DreadnoughtPlayView.width_height_from_size size
  end

  def viewbox(rect) when has_position_and_size(rect) do
    values = for key <- ~w/x y width height/a, do: Map.get(rect, key)
    Enum.join(values, " ")
  end

  def viewbox(size) when has_size(size) do
    values = for key <- ~w/width height/a, do: Map.get(size, key)
    Enum.join([0, 0 | values], " ")
  end

end
