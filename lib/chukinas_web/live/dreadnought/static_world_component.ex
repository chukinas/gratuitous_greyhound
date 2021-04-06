defmodule ChukinasWeb.Dreadnought.StaticWorldComponent do
  use ChukinasWeb, :live_component

  # TODO rename StaticWorldComponent
  # Note: this live component is actually necessary, because I never want its state to getupdated

  @impl true
  def render(assigns) do
    ~L"""
    <div
      id="worldContainer"
      class="fixed inset-0"
      phx-hook="ZoomPanContainer"
    >
      <div
        id="world"
        class="relative pointer-events-none bg-cover"
        style="width:<%= @mission.world.width %>px; height: <%= @mission.world.height %>px"
        phx-hook="ZoomPanCover"
      >
        <div
          id="fit"
          class="absolute"
          style="
            left: <%= @mission.margin.width - 50 %>px;
            top: <%= @mission.margin.height - 50 %>px;
            width:<%= @mission.grid.width + 100 %>px;
            height: <%= @mission.grid.height + 100 %>px
          "
          phx-hook="ZoomPanFit"
        >
        </div>
        <svg
          id="svg_islands"
          viewBox="
            <%= -@mission.margin.width %>
            <%= -@mission.margin.height %>
            <%=  @mission.world.width %>
            <%=  @mission.world.height %>
          "
          style="
            width:<%=  @mission.world.width  %>px;
            height:<%= @mission.world.height %>px
          "
        >
          <%= for island <- @mission.islands do %>
          <polygon
            id="island-<%= island.id %>"
            points="
              <%= for point <- island.relative_vertices do %>
              <%= point.x + island.position.x %>
              <%= point.y + island.position.y %>
              <% end %>
            "
            style="fill:green;"
          />
          <% end %>
        </svg>
        <%= live_component @socket,
          ChukinasWeb.Dreadnought.DynamicWorldComponent,
          id: :dynamic_world,
          mission: @mission %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

end
