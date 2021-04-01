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
          class="bg-green-300 absolute bg-opacity-30"
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
              grid-template-columns: repeat(20, 50px);
              grid-template-rows: repeat(15, 50px);
            "
          >
            <div
              id="gridItem"
              class="bg-yellow-400"
              style="
                grid-column-start: 20;
                grid-row-start: 15;
              "
            >
              hello
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
