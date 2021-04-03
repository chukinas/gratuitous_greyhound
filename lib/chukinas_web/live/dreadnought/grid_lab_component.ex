defmodule ChukinasWeb.Dreadnought.GridLabComponent do
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
        class="relative pointer-events-none select-none bg-cover"
        style="width:<%= @mission.world.width %>px; height: <%= @mission.world.height %>px"
        phx-hook="ZoomPanCover"
      >
        <svg
          id="svg_islands"
          class="absolute"
          viewBox="-<%= @mission.margin.width %> -<%= @mission.margin.height %> <%= @mission.grid.width + @mission.margin.width %> <%= @mission.grid.height + @mission.margin.height %> "
          style="
            width:<%= @mission.world.width %>px;
            height: <%= @mission.world.height %>px
          "
        >
          <path
            id="island-<%= @mission.island.id %>"
            d="M 200, 200 L 200 400 L 400 400 L 400 200 Z"
            style="stroke-linejoin:round;stroke-width:20;stroke:#fff;fill:green"
          />
        </svg>
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
