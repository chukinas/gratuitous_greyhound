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
  def update(%{island_specs: island_specs}, socket) when is_list(island_specs) do
    socket =
      socket
      |> assign(defs: build_defs(island_specs))
      |> assign(uses: build_uses(island_specs))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%# TODO use dynamic values %>
    <svg viewbox="0 0 1000 1000" width="1000" height="1000" overflow="visible" >
      <defs>
        <%= for def <- @defs do %>
          <%# TODO replace with a Phoenix tag builder? %>
          <%# TODO add an SvgView that renders this kinda stuff? %>
          <polygon id="<%= def.id %>" points="<%= def.polygon_points %>" fill="green" opacity="0.5" />
        <% end %>
      </defs>
      <%= for use <- @uses do %>
        <use href="<%= use.href %>" x="<%= use.pose.x %>" y="<%= use.pose.y %>" transform="rotate(<%= use.pose.angle %>)" />
      <% end %>
    </svg>
    """
  end

  # *** *******************************
  # *** SPEC.LIST CONVERTERS

  def build_defs(island_specs) do
    island_specs
    |> Spec.List.remove_dup_shapes
    |> Enum.map(&build_def/1)
  end

  def build_uses(island_specs) do
    island_specs
    |> Enum.map(&build_use/1)
  end

  # *** *******************************
  # *** SPEC CONVERTERS

  def build_def(island_spec) do
    %{
      id: element_id(island_spec),
      polygon_points: Builder.svg_polygon_points_string(island_spec)
    }
  end

  def build_use(island_spec) do
    %{
      href: "#" <> element_id(island_spec),
      pose: Spec.pose(island_spec)
    }
  end

  def element_id(island_spec), do: "island-shape-#{Spec.shape(island_spec)}"

end
