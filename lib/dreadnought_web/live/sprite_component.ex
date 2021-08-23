defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  # TODO Spec functions should be aliased. Import only the guards
    use Dreadnought.Sprite.Spec
  #alias Dreadnought.Sprite.Builder
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
      #|> assign(pose: posed_sprite |> pose_from_map)
      #|> assign(sprite: posed_sprite.sprite_spec |> Builder.build)
      |> assign(sprite_spec: sprite_spec)
      #|> assign(use_element: _render_use(sprite_spec))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg id="sprite_component" viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <defs>
        <%= _render_clippath(@sprite_spec) %>
      </defs>
      <%= _render_image(@sprite_spec, @socket) %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPRITE.SPEC CONVERTERS

  #defp _render_def(sprite_spec) when is_sprite_spec(sprite_spec) do
  #  sprite = Improved.from_sprite_spec(sprite_spec)
  #  coords = Improved.coords(sprite)
  #  SvgView.render_polygon(coords,
  #  )
  #end

  #defp _render_use(sprite_spec) when is_sprite_spec(sprite_spec) do
  #  sprite_spec
  #  |> _element_id
  #  |> SvgView.render_use
  #end

  defp _element_id(sprite_spec, :shape) do
    _element_id(sprite_spec, :sprite) <> "-shape"
  end
  defp _element_id(sprite_spec, :clippath) do
    _element_id(sprite_spec, :sprite) <> "-clippath"
  end
  defp _element_id({func_name, arg} = sprite_spec, :sprite)
  when is_sprite_spec(sprite_spec) do
    "sprite-#{func_name}-#{arg}"
  end

  defp _render_image(sprite_spec, socket) when is_sprite_spec(sprite_spec) do
    improved_sprite = Improved.from_sprite_spec(sprite_spec)
    href = Routes.static_path(socket, Improved.image_path(improved_sprite))
    size = Improved.image_size(improved_sprite)
    position = improved_sprite.image_position
    # TODO create new render_clipped_image
    SvgView.render_image(href, size,
      id: _element_id(sprite_spec, :sprite),
      x: position.x,
      y: position.y,
      clip_path: "url(##{_element_id(sprite_spec, :clippath)})"
    )
  end

  defp _render_clippath(sprite_spec) when is_sprite_spec(sprite_spec) do
    improved_sprite = Improved.from_sprite_spec(sprite_spec)
    id = _element_id(sprite_spec, :clippath)
    coords = Improved.coords(improved_sprite)
    SvgView.render_clippath(id, coords)
  end

  #defp sprite(sprite_spec) do
  #  Builder.build(sprite_spec)
  #  |> IOP.inspect(__MODULE__)
  #end

end
