alias Chukinas.Dreadnought.Mission
alias Chukinas.Geometry.{Position}

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
      style="width:<%= @mission.world.width %>px; height: <%= @mission.world.height %>px"
    >
      <div
        id="world"
        class="relative pointer-events-none select-none bg-cover"
        style="width:<%= @mission.world.width %>px; height: <%= @mission.world.height %>px"
      >
        <div
          id="arena"
          class="absolute bg-green-300 bg-opacity-30"
          style="
            left: <%= @mission.margin.width %>px;
            top: <%= @mission.margin.height %>px;
            width:<%= @mission.grid.width %>px;
            height: <%= @mission.grid.height %>px
          "
        >
          <div
            id="arenaGrid"
            style="
              display: grid;
              grid-auto-columns: <%= @mission.grid.square_size %>px;
              grid-auto-rows: <%= @mission.grid.square_size %>px;
            "
          >
            <%= for square <- @mission.squares do %>
            <button
              id="gridSquareTarget-<%= square.id %>"
              class="p-2 hover:p-1 pointer-events-auto"
              style="
                grid-column-start: <%= square.column %>;
                grid-row-start: <%= square.row %>;
              "
              phx-click="select_square"
              phx-target="<%= @myself %>"
              phx-value-x="<%= square.center.x %>"
              phx-value-y="<%= square.center.y %>"
            >
              <div
                id="gridSquareVisible-<%= square.id %>"
                class="bg-yellow-400 h-full rounded-sm bg-opacity-20"
              >
              </div>
            </button>
            <% end %>
          </div>
        </div>
        <%= ChukinasWeb.DreadnoughtView.render "unit2.html", %{unit: @mission.unit}%>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("select_square", %{"x" =>  x, "y" => y}, socket) do
    socket.assigns |> Map.keys |> IOP.inspect("assigns")
    position = Position.new(String.to_float(x), String.to_float(y)) |> IOP.inspect
    {:noreply, update(socket, :mission, &Mission.move_unit_to(&1, position))}
  end

end
