alias Chukinas.Dreadnought.Unit
alias Chukinas.Geometry.{Pose, Position}
alias Chukinas.LinearAlgebra.CSys.Conversion
alias Chukinas.LinearAlgebra.Vector
alias Chukinas.Util.Opts

defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  # TODO I don't like this use of 'opts'. The two 'opts' are anything but. They're required.
  def sprite(opts \\ []) do
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
      id_string: nil,
      phx_hook: nil,
      pose: Pose.origin()
    ])
    pose = opts[:pose]
    angle = case pose.angle do
      0 -> nil
      x when is_number(x) -> x
    end
    assigns = %{
      sprite: sprite,
      socket: socket,
      id_string: opts[:id_string],
      position: sprite.rect |> Position.add(pose) |> Position.new,
      phx_hook: opts[:phx_hook],
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
