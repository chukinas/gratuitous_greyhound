defmodule DreadnoughtWeb.IslandComponent do

    use DreadnoughtWeb, :live_component
  alias Dreadnought.Core.Island.Builder
  alias Dreadnought.Core.Island.Spec

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{island_specs: island_specs}, socket) do
    socket =
      socket
      |> assign(defs: build_defs(island_specs))
      |> assign(uses: nil)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <defs>
      <%= for def <- @defs do %>
        <%# TODO replace with a Phoenix tag builder? %>
        <polygon id="<%= def.id %>" points="<%= def.polygon_points %>" />
      <% end %>
    </defs>
    """
  end

  # *** *******************************
  # *** SPEC.LIST CONVERTERS

  def build_defs(island_specs) do
    island_specs
    |> Spec.List.remove_dup_shapes
    |> Enum.map(&build_def/1)
  end

  # *** *******************************
  # *** SPEC CONVERTERS

  def build_def(island_spec) do
    %{
      id: element_id(island_spec),
      polygon_points: Builder.svg_polygon_points_string(island_spec)
    }
  end

  def element_id(island_spec), do: "island-shape-#{Spec.shape(island_spec)}"

end
