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
            <%= for square <- @squares do %>
            <div
              id="gridSquareTarget-<%= square.id %>"
              class="p-2 hover:p-1 pointer-events-auto"
              style="
                grid-column-start: <%= square.column %>;
                grid-row-start: <%= square.row %>;
              "
            >
              <div
                id="gridSquareVisible-<%= square.id %>"
                class="bg-yellow-400 h-full rounded-sm bg-opacity-40"
              >
              </div>
            </div>
            <% end %>
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
