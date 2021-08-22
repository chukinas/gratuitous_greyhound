defmodule DreadnoughtWeb.SpriteComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite
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
      |> assign(def_element: render_def_element(sprite_spec))
      |> assign(use_element: render_use_element(sprite_spec))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg id="sprite_component" viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <defs><%= @def_element %></defs>
      <%= @use_element %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPEC CONVERTERS

  def render_def_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite =
      sprite_spec
      |> Sprite.Builder.build
      |> IOP.inspect(__MODULE__)
    points_offset =
      sprite.image_origin
      |> position_multiply(-1)
      |> vector_from_position
    points =
      sprite.image_clip_path
      |> Svg.PathDString.to_coords
      |> Enum.map(&vector_add(&1, points_offset))
      |> Svg.polygon_points_string_from_coords
    content_tag(:polygon, nil,
      id: element_id(sprite_spec),
      points: points,
      fill: "red",
      stroke: "black",
      opacity: 0.7
    )
  end

  def render_use_element(sprite_spec) when is_sprite_spec(sprite_spec) do
    content_tag(:use, nil,
      href: "#" <> element_id(sprite_spec)
    )
  end

  def element_id({func_name, arg} = sprite_spec) when is_sprite_spec(sprite_spec), do: "sprite-shape-#{func_name}-#{arg}"

end
