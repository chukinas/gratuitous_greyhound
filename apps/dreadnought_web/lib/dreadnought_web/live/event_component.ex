# TODO this isn't actually a
defmodule DreadnoughtWeb.Event do

  import Phoenix.HTML.Tag
  alias Dreadnought.Core.Unit
  # TODO should this not be nested under Unit?
  alias Dreadnought.Core.Unit.Event.Maneuver

  # TODO supersedes maneuvers.html and whatever invokes that template
  def maneuvers(units) when is_list(units) do
    content_tag(
      :g,
      Enum.flat_map(units, &unit_maneuvers/1),
      # TODO id; "maneuver_events",
      id: "svg_paths",
      opacity: 0.2,
      #stroke_width: 60,
      stroke: "white",
      fill: "none"
    )
  end

  defp unit_maneuvers(%Unit{} = unit) do
    unit
    |> Unit.events
    |> Enum.map(&maneuver(&1, Unit.id(unit)))
  end

  defp maneuver(%Maneuver{} = maneuver, unit_id) do
    # TODO supersedes PlayView.render_single_maneuver
    # TODO superseded maneuver_path.html
    # TODO do I need an element_id module?
    unit_el_id = "unit-#{unit_id}"
    content_tag(
      :path,
      nil,
      id: "#{unit_el_id}-path-#{maneuver.id}",
      d: maneuver.svg_path,
      data: [
        maneuvering_el_id: unit_el_id,
        start: maneuver.fractional_start_time,
        duration: maneuver.fractional_duration
      ]
    )
  end
  def render_maneuver_path(_other_event_type, _unit_id), do: nil

end
