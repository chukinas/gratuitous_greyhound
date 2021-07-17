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

  def attrs(nil), do: nil
  def attrs(attrs) when is_list(attrs) do
    assigns = [attrs: (for attr <- attrs, do: attr_to_map(attr))]
    ChukinasWeb.SharedView.render("attrs.html", assigns)
  end

  defp attr_to_map({name, value}), do: %{name: Atom.to_string(name), value: value}

end
