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
  # *** HELPERS

  def build_defs(island_specs) do
    # TODO the SPec.List fun should return island specs via Enum.uniq_by
    unique_shapes = Spec.List.unique_shapes(island_specs)
    Enum.map(unique_shapes, fn shape ->
      %{
        id: element_id(shape),
        polygon_points: Builder.svg_polygon_points_string(shape)
      }
    end)
  end

  def element_id(shape_name), do: "island-shape-#{shape_name}"

end
