defmodule DreadnoughtWeb.Shared do

  use Spatial.PositionOrientationSize
  alias DreadnoughtWeb.PlayView
  alias Spatial.Geometry.Rect

  def top_left_width_height_from_rect(rect) do
    # TODO extract all these methods into this module
    PlayView.render_rect_as_style_attrs(rect)
  end

  def left_top_from_number(number) when is_number(number) do
    number
    |> position_new(number)
    |> left_top_from_position
  end

  def left_top_from_position(position) do
    PlayView.left_top_from_position position
  end

  def width_height_from_size(size) do
    PlayView.width_height_from_size size
  end

  def viewbox(rect_or_size, margin \\ 0)

  def viewbox(rect, margin) when has_position_and_size(rect) do
    rect =
      rect
      |> Rect.from_rect
      |> Rect.grow(margin)
    values = for key <- ~w/x y width height/a, do: Map.get(rect, key)
    Enum.join(values, " ")
  end

  def viewbox(size, margin) when has_size(size) do
    size
    |> Rect.from_size
    |> viewbox(margin)
  end

  # TODO rename render_attrs
  # TODO move to SharedView
  def attrs(nil), do: nil
  def attrs(attrs) when is_list(attrs) do
    assigns = [attrs: (for attr <- attrs, do: attr_to_map(attr))]
    DreadnoughtWeb.SharedView.render("attrs.html", assigns)
  end

  defp attr_to_map(%{name: _name, value: _value} = map), do: map
  defp attr_to_map({name, value}), do: %{name: Atom.to_string(name), value: value}

  def hide_livereload_iframe do
    import Phoenix.HTML
    ~E"""
    <style>
      iframe {
        width: 0;
        height: 0;
      }
    </style>
    """
  end

end
