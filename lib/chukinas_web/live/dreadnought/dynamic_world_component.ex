alias Chukinas.Dreadnought.Mission
alias Chukinas.Geometry.{Position}

defmodule ChukinasWeb.Dreadnought.DynamicWorldComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    # TODO is it a problem that there isn't a single root element here? %>
    # TODO might be worth having a containing div so I only have to set margin and size once
    ~L"""
    <div
      id="arena"
      class="absolute bg-green-300 bg-opacity-30"
      style="
        left: <%= @mission.margin.width %>px;
        top: <%= @mission.margin.height %>px;
        width:<%= @mission.grid.width %>px;
        height: <%= @mission.grid.height %>px
      "
      phx-hook="ZoomPanFit"
      phx-update="replace"
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
          class="p-0.5 hover:p-0 pointer-events-auto"
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
    <svg
      id="svg_paths"
      class="absolute pointer-event-none"
      viewBox="0 0 <%= @mission.grid.width %> <%= @mission.grid.height %> "
      style="
        left: <%= @mission.margin.width %>px;
        top: <%= @mission.margin.height %>px;
        width:<%= @mission.grid.width %>px;
        height: <%= @mission.grid.height %>px
      "
    >
      <path
        d="<%= @mission.unit.path_string %>"
        style="stroke-linejoin:round;stroke-width:2.5;stroke:#fff;fill:none"
      />
    </svg>
    <%= ChukinasWeb.DreadnoughtView.render "unit2.html", %{unit: @mission.unit}%>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("select_square", %{"x" =>  x, "y" => y}, socket) do
    position = Position.new(String.to_float(x), String.to_float(y)) |> IOP.inspect("command")
    {:noreply, update(socket, :mission, &Mission.move_unit_to(&1, position))}
  end

end
