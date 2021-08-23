defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite
  alias Dreadnought.Sprite.Improved
  alias Dreadnought.Svg

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{posed_sprite: posed_sprite}, socket) do
    sprite_spec = posed_sprite.sprite_spec
    socket =
      socket
      |> assign(pose: posed_sprite |> pose_from_map)
      |> assign(sprite: posed_sprite.sprite_spec |> Sprite.Builder.build)
      |> assign(sprite_spec: sprite_spec)
      |> assign(def_element: render_def_element(sprite_spec))
      |> assign(use_element: render_use_element(sprite_spec))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg id="sprite_component" viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <%= render_image_element(@sprite_spec, @socket) %>
      <defs><%= @def_element %></defs>
      <%= @use_element %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPRITE.SPEC CONVERTERS

  def render_def_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite = Improved.from_sprite_spec(sprite_spec)
    Svg.render_polygon(Improved.coords(sprite),
      id: element_id(sprite_spec),
      fill: "red",
      stroke: "black",
      opacity: 0.7
    )
  end

  def render_use_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec
    |> element_id
    |> Svg.render_use
  end

  def element_id({func_name, arg} = sprite_spec) when is_sprite_spec(sprite_spec), do: "sprite-shape-#{func_name}-#{arg}"

  def render_image_element(sprite_spec, socket) when is_sprite_spec(sprite_spec) do
    %Sprite{image_file_path: path, image_size: size} = sprite(sprite_spec)
    href = Routes.static_path(socket, path)
    Svg.render_image(href, size,
      opacity: 0.7
    )
  end

  def sprite(sprite_spec) do
    Sprite.Builder.build(sprite_spec)
    |> IOP.inspect(__MODULE__)
  end

end
