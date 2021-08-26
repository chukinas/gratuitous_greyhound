defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  # TODO Spec functions should be aliased. Import only the guards
    use Dreadnought.Sprite.Spec
  alias Dreadnought.BoundingRect
  alias Dreadnought.Geometry.Rect
  alias Dreadnought.Sprite.Improved
  alias Dreadnought.Svg
  alias DreadnoughtWeb.SvgView

  # *** *******************************
  # *** CONSTRUCTORS

  def render_defs(sprite_specs) when is_list(sprite_specs) do
    Phoenix.LiveView.Helpers.live_component(__MODULE__,
      sprite_specs: sprite_specs,
      include: :defs
    )
  end

  def render_uses(sprite_specs) when is_list(sprite_specs) do
    Phoenix.LiveView.Helpers.live_component(__MODULE__,
      sprite_specs: sprite_specs,
      include: :uses
    )
  end

  def render_list(sprite_specs) when is_list(sprite_specs) do
    Phoenix.LiveView.Helpers.live_component(__MODULE__,
      sprite_specs: sprite_specs,
      include: :all
    )
  end

  def render_single_as_block(sprite_spec, scale \\ 1) when is_sprite_spec(sprite_spec) do
    Phoenix.LiveView.Helpers.live_component(__MODULE__,
      sprite_specs: [sprite_spec],
      include: :all,
      as_block: true,
      scale: scale
    )
  end

  # *** *******************************
  # *** CALLBACKS

  # TODO needed?
  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{sprite_specs: sprite_specs, include: include} = assigns, socket)
  when include in ~w/defs uses all/a do
    socket =
      socket
      |> assign(sprite_specs: sprite_specs)
      |> assign(as_block: !!assigns[:as_block])
      |> assign(incl_defs?: include != :uses)
      |> assign(incl_uses?: include != :defs)
      |> assign(scale: Map.get(assigns, :scale, 1))
      |> IOP.inspect
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= _render_svg(@sprite_specs, @as_block, @scale) %>
      <%= if @incl_defs? do %>
        <defs>
          <%= _render_shape_defs(@sprite_specs) %>
          <%= _render_clippath_defs(@sprite_specs) %>
          <%= _render_sprite_defs(@sprite_specs, @socket) %>
        </defs>
      <% end %>
      <%= if @incl_uses? do %>
        <%= _render_sprite_uses(@sprite_specs, @as_block) %>
      <% end %>
    </svg>
    """
  end

  # TODO reduce duplication

  # *** *******************************
  # *** SPRITE.SPEC.LIST CONVERTERS

  # TODO as_block should end in question mark
  def _render_svg(sprite_specs, as_block, scale) when is_list(sprite_specs) do
    rect =
      sprite_specs
      |> BoundingRect.of
    # TODO I shouldn't have to do this step. There's no need to translate the use
      |> Rect.from_size
    size =
      if scale == 1 do
        rect
      else
        rect |> Rect.scale(scale)
      end
    attrs =
      [
        id: "sprite_component",
        overflow: "visible"
      ]
      |> Svg.Viewbox.put_attr(rect)
      |> Svg.Size.put(size)
    tag(:svg, attrs)
  end

  # TODO the gallery sprites have an unwanted left margin

  def _render_shape_defs(sprite_specs) when is_list(sprite_specs) do
    for sprite_spec <- sprite_specs, do: _render_shape_def(sprite_spec)
  end

  def _render_clippath_defs(sprite_specs) when is_list(sprite_specs) do
    for sprite_spec <- sprite_specs, do: _render_clippath_def(sprite_spec)
  end

  def _render_sprite_defs(sprite_specs, socket) when is_list(sprite_specs) do
    for sprite_spec <- sprite_specs, do: _render_sprite_def(sprite_spec, socket)
  end

  def _render_sprite_uses(sprite_specs, as_block) when is_list(sprite_specs) do
    for sprite_spec <- sprite_specs, do: _render_sprite_use(sprite_spec, as_block)
  end

  # *** *******************************
  # *** SPRITE.SPEC CONVERTERS

  defp _viewbox(sprite_specs, hidden?) do
    if hidden? do
      "0 0 0 0"
    else
      "0 0 1000 1000"
    end
  end

  defp _render_shape_def(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite = Improved.from_sprite_spec(sprite_spec)
    coords = Improved.coords(sprite)
    SvgView.render_polygon(coords,
      id: _element_id(sprite_spec, :shape)
    )
  end

  defp _render_clippath_def(sprite_spec) when is_sprite_spec(sprite_spec) do
    id = _element_id(sprite_spec, :clippath)
    href_id = _element_id(sprite_spec, :shape)
    SvgView.render_clippath_use(id, href_id)
  end

  defp _render_sprite_def(sprite_spec, socket) when is_sprite_spec(sprite_spec) do
    content = [
      _render_dropshadow(sprite_spec),
      _render_clipped_image(sprite_spec, socket),
    ]
    content_tag(:g, content, id: _element_id(sprite_spec, :sprite))
  end

  defp _render_clipped_image(sprite_spec, socket) when is_sprite_spec(sprite_spec) do
    improved_sprite = Improved.from_sprite_spec(sprite_spec)
    href = Routes.static_path(socket, Improved.image_path(improved_sprite))
    size = Improved.image_size(improved_sprite)
    position = improved_sprite.image_position
    # TODO create new render_clipped_image
    SvgView.render_image(href, size,
      x: position.x,
      y: position.y,
      clip_path: "url(##{_element_id(sprite_spec, :clippath)})"
    )
  end

  defp _render_dropshadow(sprite_spec) when is_sprite_spec(sprite_spec) do
    href_id = _element_id(sprite_spec, :shape)
    SvgView.render_dropshadow_use(href_id)
  end

  defp _render_sprite_use(sprite_spec, as_block)
  when is_sprite_spec(sprite_spec)
  and is_boolean(as_block) do
    href_id = _element_id(sprite_spec, :sprite)
    attrs =
      if as_block do
        bounding_rect =
          sprite_spec
          |> Improved.from_sprite_spec
          |> BoundingRect.of
        [
          x: -bounding_rect.x,
          y: -bounding_rect.y
        ]
      else
        []
      end
    SvgView.render_use(href_id, attrs)
  end

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

end
