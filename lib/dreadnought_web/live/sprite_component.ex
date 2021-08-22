defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite
  #alias Dreadnought.Svg

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
      |> assign(def: render_def_element(sprite_spec))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg id="sprite_component" viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <defs>
        <%= @def %>
      </defs>
      <%= @def %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPEC CONVERTERS

  def render_def_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite = sprite_spec |> Sprite.Builder.build
    tag(:path,
      #id: "my-pretty-sprite-def",
      d: sprite.image_clip_path,
      fill: "green",
      opacity: 0.7
    )
  end

  #def render_use_element(island_spec) do
  #  pose_attrs =
  #    island_spec
  #    |> Spec.pose
  #    |> Svg.pose_to_attrs
  #  tag(:use, Keyword.merge(pose_attrs,
  #    href: "#" <> element_id(island_spec)
  #  ))
  #end

  #def element_id(island_spec), do: "island-shape-#{Spec.shape(island_spec)}"

end
