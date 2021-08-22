defmodule DreadnoughtWeb.IslandComponent do

    use DreadnoughtWeb, :live_component
  alias Dreadnought.Core.Island.Builder
  alias Dreadnought.Core.Island.Spec
  alias Dreadnought.Svg

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{island_specs: island_specs}, socket) when is_list(island_specs) do
    socket =
      socket
      |> assign(def_elements: render_def_elements(island_specs))
      |> assign(use_elements: render_use_elements(island_specs))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg id="island_component" viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <defs><%= @def_elements %></defs>
      <%= @use_elements %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPEC.LIST CONVERTERS

  def render_def_elements(island_specs) do
    island_specs
    |> Spec.List.remove_dup_shapes
    |> Enum.map(&render_def_element/1)
  end

  def render_use_elements(island_specs) do
    island_specs
    |> Enum.map(&render_use_element/1)
  end

  # *** *******************************
  # *** SPEC CONVERTERS

  def render_def_element(island_spec) do
    # TODO may need to use content_tag since tag/1 doesn't self-close
    tag(:polygon,
      id: element_id(island_spec),
      points: Builder.svg_polygon_points_string(island_spec),
      fill: "green",
      opacity: 0.7
    )
  end

  def render_use_element(island_spec) do
    pose_attrs =
      island_spec
      |> Spec.pose
      |> Svg.pose_to_attrs
    # TODO may need to use content_tag since tag/1 doesn't self-close
    tag(:use, Keyword.merge(pose_attrs,
      href: "#" <> element_id(island_spec)
    ))
  end

  def element_id(island_spec), do: "island-shape-#{Spec.shape(island_spec)}"

end
