defmodule DreadnoughtWeb.UnitView do

  use DreadnoughtWeb, :view
  use DreadnoughtWeb.Components
  use Spatial.PositionOrientationSize
  use Spatial.LinearAlgebra
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.Unit.Event, as: Ev

  def unit_event(%Ev.Maneuver{} = event) do
    standard_attributes(event, "maneuver") ++ [
      data_attr("id", event.id),
    ]
    |> render_event
  end

  def unit_event(%Ev.MountRotation{} = event) do
    # TODO move all this event stuff to separate view?
    standard_attributes(event, "mountRotation") ++ [
      data_attr("mount-id", event.mount_id),
      data_attr("direction", event.angle_direction),
      data_attr("start-angle", event.angle_start),
      data_attr("end-angle", event.angle_end)
    ]
    |> render_event
  end

  def unit_event(%Ev.Fadeout{} = event) do
    standard_attributes(event, "fadeout") |> render_event
  end

  def unit_event(non_animated_event) do
    nil = Ev.delay_and_duration(non_animated_event)
    nil
  end

  defp data_attr(key, value), do: %{name: "data-#{key}", value: value}

  defp standard_attributes(event, event_type) do
    {delay, duration} = Ev.delay_and_duration(event)
    [
      data_attr("event-type", event_type),
      data_attr("delay", delay),
      data_attr("duration", duration)
    ]
  end
  def render_event(attributes) do
    render("unit_event.html", attributes: attributes)
  end

  def render_unit(socket, %Unit{} = unit, turn_number \\ 0) do
    if Unit.render?(unit), do: render("unit.html", socket: socket, turn_number: turn_number, unit: unit)
  end

  def _render_unit(_socket, %Unit{} = unit, _turn_number \\ 0) do
    content_tag(
      :svg,
      [
        # TODO scale shouldn't be required
        # TODO defs should be rendered separately?
        DreadnoughtWeb.SpriteComponent.render_single(unit.sprite_spec, 1)
      ],
      id: "unit-#{unit.id}",
      data: [unit_id: unit.id]
    )
  end

end
