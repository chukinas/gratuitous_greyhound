defmodule ChukinasWeb.UnitView do

  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Dreadnought.Unit.Event, as: Ev

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

end
