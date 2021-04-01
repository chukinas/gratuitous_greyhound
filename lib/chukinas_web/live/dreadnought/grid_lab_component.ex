defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use ChukinasWeb, :live_component

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
      phx-hook="WorldContainerPanZoom"
      style="width:<%= @world.width %>px; height: <%= @world.height %>px"
    >
      <div
        id="world"
        class="relative pointer-events-none select-none bg-cover"
        style="width:<%= @world.width %>px; height: <%= @world.height %>px"
      >
        <div
          id="arena"
          class="absolute"
          style="
            left: <%= @margin.width %>px;
            top: <%= @margin.height %>px;
            width:<%= @grid.width %>px;
            height: <%= @grid.height %>px
          "
        >
          <div
            id="arenaGrid"
            style="
              display: grid;
              grid-auto-columns: <%= @grid.square_size %>px;
              grid-auto-rows: <%= @grid.square_size %>px;
            "
          >
            <div
              id="gridSquareTarget-10-7"
              class="p-2 hover:p-1 pointer-events-auto"
              style="
                grid-column-start: 10;
                grid-row-start: 7;
              "
            >
              <div
                id="gridSquareVisible-10-7"
                class="bg-yellow-400 h-full rounded-sm bg-opacity-40"
              >
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

end
