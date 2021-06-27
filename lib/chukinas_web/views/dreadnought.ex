alias Chukinas.Dreadnought.{Unit}
alias Chukinas.Util.Opts
alias Unit.Event, as: Ev

defmodule ChukinasWeb.DreadnoughtView do

  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra

  def maneuver_path(%Ev.Maneuver{} = path, unit_id) do
    assigns =
      path
      |> Map.from_struct
      |> Map.put(:unit_el_id, "unit-#{unit_id}")
    render("maneuver_path.html", assigns)
  end
  def maneuver_path(_, _) do
    nil
  end

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
    render("_unit_event.html", attributes: attributes)
  end

  def sprite(opts \\ []) do
    # TODO I don't like this use of 'opts'. The two 'opts' are anything but. They're required.
    sprite = Keyword.fetch!(opts, :sprite)
    rect = sprite.rect
    assigns = [
      socket: Keyword.fetch!(opts, :socket),
      rect: rect,
      image_file_path: sprite.image_file_path,
      image_size: sprite.image_size,
      image_clip_path: sprite.image_clip_path,
      transform: sprite.image_origin |> position_add(sprite.rect) |> position_multiply(-1)
    ]
    render("_sprite.html", assigns)
  end

  def relative_sprite(sprite, socket, opts \\ []) do
    opts = Opts.merge!(opts, [
      attributes: [],
      class: "",
      pose: pose_origin()
    ])
    pose = opts[:pose]
    attributes =
      opts[:attributes]
      |> Enum.map(fn {name, value} -> %{name: Atom.to_string(name), value: value} end)
    angle = case pose.angle do
      0 -> nil
      x when is_number(x) -> x
    end
    assigns = %{
      sprite: sprite,
      socket: socket,
      position: sprite.rect |> position_add(pose) |> position,
      class: opts[:class],
      attributes: attributes,
      angle: angle
    }
    render("_relative_sprite.html", assigns)
  end

  def center(%{x: x, y: y}, opts \\ []) do
    scale = Keyword.get(opts, :scale, 1)
    color = case Keyword.get(opts, :type, :origin) do
      :origin -> "pink"
      :mount -> "blue"
    end
    size = 20
    assigns = [size: size, left: x * scale - size / 2, top: y * scale - size / 2, color: color]
    render("_center.html", assigns)
  end

  def unit_selection_box(myself, %Unit{} = unit) do
    box_size = 200
    box_position =
      unit
      |> Unit.center_of_mass
      |> vector_inner_to_outer([unit])
      |> position_from_vector
      |> position_subtract(box_size / 2)
    assigns =
      [
        unit_id: unit.id,
        unit_name: unit.name,
        size: box_size,
        position: box_position,
        myself: myself
      ]
    render("_unit_selection_box.html", assigns)
  end

  #defp render_template(template, assigns, block) do
  #  assigns =
  #    assigns
  #    |> Map.new()
  #    |> Map.put(:inner_content, block)
  #  render template, assigns
  #end

end
