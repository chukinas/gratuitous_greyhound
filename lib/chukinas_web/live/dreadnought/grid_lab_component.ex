defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use ChukinasWeb, :live_component

  # TODO This is now a rather aenemic little component which should be downgraded to a simple template
  @impl true
  def render(assigns) do
    ~L"""
    <style>
      body {
        touch-action:none
      }
      #world {
        background-image:url("<%= Routes.static_path @socket, "/images/ocean.png" %>")
      }
    </style>
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
