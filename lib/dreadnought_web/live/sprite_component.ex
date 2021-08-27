# TODO Maybe all the defs should be written to an svg static file at runtime
defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
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

  def render_single(sprite_spec, scale \\ 1, insert_svg)
  when is_sprite_spec(sprite_spec) do
    Phoenix.LiveView.Helpers.live_component(__MODULE__,
      sprite_specs: [sprite_spec],
      include: :all,
      scale: scale,
      insert_svg: insert_svg
    )
  end

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(%{sprite_specs: sprite_specs, include: include} = assigns, socket)
  when include in ~w/defs uses all/a do
    socket =
      socket
      |> assign(sprite_specs: sprite_specs)
      |> assign(incl_defs?: include != :uses)
      |> assign(incl_uses?: include != :defs)
      |> assign(scale: Map.get(assigns, :scale, 1))
      |> assign(insert_svg: Map.get(assigns, :insert_svg))
      |> IOP.inspect
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= _render_svg(@sprite_specs, @scale) %>
      <%= if @incl_defs? do %>
        <%= for s <- @sprite_specs do %>
          <%= content_tag(:defs, [
            _render_shape_def(s),
            _render_clippath_def(s),
            _render_sprite_def(s, @socket)
          ]) %>
        <% end %>
      <% end %>
      <%= if @incl_uses?, do: for s <- @sprite_specs, do: _render_sprite_use(s) %>
      <circle r="4" cx="0" cy="0" fill="red" />
    </svg>
    """
  end

  # *** *******************************
  # *** SPRITE.SPEC.LIST CONVERTERS

  def _render_svg(sprite_specs, scale) when is_list(sprite_specs) do
    rect =
      sprite_specs
      |> BoundingRect.of
    size =
      if scale == 1 do
        rect
      else
        rect |> Rect.scale(scale)
      end
    attrs =
      [
        overflow: "visible"
      ]
      |> Svg.Viewbox.put_attr(rect)
      |> Svg.Position.put_attrs(rect)
      |> Svg.Size.put_attrs(size)
    tag(:svg, attrs)
  end

  # TODO the gallery sprites have an unwanted left margin

  # *** *******************************
  # *** SPRITE.SPEC CONVERTERS

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

  defp _render_sprite_use(sprite_spec)
  when is_sprite_spec(sprite_spec) do
    href_id = _element_id(sprite_spec, :sprite)
    SvgView.render_use(href_id)
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
