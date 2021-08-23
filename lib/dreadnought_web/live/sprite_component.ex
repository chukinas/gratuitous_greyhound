defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  # TODO Spec functions should be aliased. Import only the guards
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite.Builder
  alias Dreadnought.Sprite.Improved
  alias DreadnoughtWeb.SvgView

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
      |> assign(sprite: posed_sprite.sprite_spec |> Builder.build)
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
      <defs>
        <%= render_clippath_element(@sprite_spec) %>
      </defs>
      <%= render_image_element(@sprite_spec, @socket) %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPRITE.SPEC CONVERTERS

  def render_def_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite = Improved.from_sprite_spec(sprite_spec)
    SvgView.render_polygon(Improved.coords(sprite))
  end

  def render_use_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec
    |> element_id
    |> SvgView.render_use
  end

  def element_id({func_name, arg} = sprite_spec) when is_sprite_spec(sprite_spec), do: "sprite-shape-#{func_name}-#{arg}"

  def render_image_element(sprite_spec, socket) when is_sprite_spec(sprite_spec) do
    improved_sprite = Improved.from_sprite_spec(sprite_spec)
    href = Routes.static_path(socket, Improved.image_path(improved_sprite))
    size = Improved.image_size(improved_sprite)
    position = improved_sprite.image_position
    SvgView.render_image(href, size,
      #opacity: 0.5,
      x: position.x,
      y: position.y,
      clip_path: "url(##{element_id(sprite_spec)})"
    )
  end

  def render_clippath_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    improved_sprite = Improved.from_sprite_spec(sprite_spec)
    id = element_id(sprite_spec)
    coords = Improved.coords(improved_sprite)
    SvgView.render_clippath(id, coords)
  end

  def sprite(sprite_spec) do
    Builder.build(sprite_spec)
    |> IOP.inspect(__MODULE__)
  end

end
