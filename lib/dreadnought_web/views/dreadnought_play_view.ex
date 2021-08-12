defmodule DreadnoughtWeb.DreadnoughtPlayView do

  use DreadnoughtWeb, :view
  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.Unit.Event.Maneuver
  alias Dreadnought.Core.ActionSelection, as: AS
  alias Dreadnought.Geometry.Rect

  # TODO rename
  def render_single_maneuver(%Maneuver{} = path, unit_id) do
    assigns =
      path
      |> Map.from_struct
      |> Map.put(:unit_el_id, "unit-#{unit_id}")
    render("maneuver_path.html", assigns)
  end

  def render_single_maneuver(_, _) do
    nil
  end

  # TODO swap the two params
  def render_unit_selection_box(target \\ nil, %Unit{} = unit) do
    box_size = 200
    box_position =
      unit
      |> Unit.center_of_mass
      |> vector_from_position
      |> vector_wrt_outer_observer(unit)
      |> position_from_vector
      |> position_subtract(box_size / 2)
    assigns =
      [
        unit_id: unit.id,
        unit_name: unit.name,
        size: box_size,
        position: box_position,
        # TODO rename `target`
        myself: target
      ]
    render("_unit_selection_box.html", assigns)
  end

  def render_action_selection(action_selection, target \\ nil)

  def render_action_selection(nil, _), do: nil

  def render_action_selection(%AS.Maneuver{} = action_selection, target) do
    render "action_selection_maneuver.html", action_selection: action_selection, target: target
  end

  def render_zoom_pan_fit_area(arena_size) do
    margin = 50
    position =
      position_null()
      |> position_subtract(margin)
    size =
      arena_size
      |> size_add(2 * margin)
    rect = Rect.from_position_and_size(
      position,
      size
    )
    render "zoom_pan_fit_area.html", rect: rect
  end

  # TODO move these to the Shared View
  def render_rect_as_style_attrs(rect) do
    rect
    |> Rect.from_rect
    |> Map.from_struct
    |> Enum.map(&attr_mapping/1)
    # TODO investigate using io list
    |> Enum.join(" ")
  end

  def left_top_from_position(position) do
    position
    |> position_new
    |> Map.from_struct
    |> Enum.map(&attr_mapping/1)
    |> Enum.join(" ")
  end

  def width_height_from_size(size) when is_number(size) do
    size
    |> size_from_square
    |> width_height_from_size
  end

  def width_height_from_size(size) do
    size
    |> size_new
    |> Map.from_struct
    |> Enum.map(&attr_mapping/1)
    |> Enum.join(" ")
  end

  defp attr_mapping(tuple) do
    case tuple do
      {:x, val} -> "left: #{val}px;"
      {:y, val} -> "top: #{val}px;"
      {:width, val} -> "width: #{val}px;"
      {:height, val} -> "height: #{val}px;"
    end
  end
end
