alias Chukinas.Dreadnought.{Unit}
alias Chukinas.Geometry.{Pose, Position}
alias Chukinas.LinearAlgebra.CSys.Conversion
alias Chukinas.LinearAlgebra.Vector
alias Chukinas.Util.Opts
alias Unit.Event, as: Ev

defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view
  alias ChukinasWeb.Helpers, as: Element
  alias ChukinasWeb.CssClasses, as: Class

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
      transform: sprite.image_origin |> Position.add(sprite.rect) |> Position.multiply(-1)
    ]
    render("_sprite.html", assigns)
  end

  def relative_sprite(sprite, socket, opts \\ []) do
    opts = Opts.merge!(opts, [
      attributes: [],
      class: "",
      pose: Pose.origin()
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
      position: sprite.rect |> Position.add(pose) |> Position.new,
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

  def button(opts \\ []) do
    assigns = Opts.merge!(opts,
      text: "placeholder text",
      phx_click: nil,
      phx_target: nil
    )
    render("_button.html", assigns)
  end

  def toggle(id, opts \\ []) do
    assigns =
      [
        label: nil,
        phx_click: nil,
        phx_target: nil,
        is_enabled?: false
      ]
      |> Keyword.merge(opts)
      |> Keyword.put(:id, id)
    render("_toggle.html", assigns)
  end

  def unit_selection_box(myself, %Unit{} = unit) do
    box_size = 200
    box_position =
      unit
      |> Unit.center_of_mass
      |> Vector.new
      |> Conversion.convert_to_world_vector(unit)
      |> Position.new
      |> Position.subtract(box_size / 2)
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


defmodule ChukinasWeb.Helpers do
  use Phoenix.HTML
  alias ChukinasWeb.CssClasses, as: Class

  def valid?(form, field) do
    # TODO implement
    false
  end

  def valid(form, field) do
    if valid?(form, field), do: :valid, else: :invalid
  end

  def text_input(form, field) do
    class = Class.text_input(valid form, field)
    Phoenix.HTML.Form.text_input(form, field, class: class)
  end
end

# TODO move error_icon... do here
# TODO extract these functions out into another file
# TODO the tab underline in menu aren't highlighting

defmodule ChukinasWeb.CssClasses do
  def text_input(:valid), do: "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
  def text_input(:invalid), do: "block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm rounded-md"
  def label, do: "block text-sm font-medium text-gray-700"
  def error_paragraph do
    "mt-2 text-sm text-red-600"
  end
  def submit do
    "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
  end
end
