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
      class="absolute rounded-3xl"
      style="
        box-shadow: inset 10px 10px 50px, 2px 2px 10px aquamarine;
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
          class="p-0.5 hover:p-0 pointer-events-auto"
          style="
            grid-column-start: <%= square.column %>;
            grid-row-start: <%= square.row %>;
          "
          phx-click="select_square"
          phx-target="<%= @myself %>"
          phx-value-x="<%= square.center.x %>"
          phx-value-y="<%= square.center.y %>"
          phx-value-type="<%= square.path_type %>"
        >
          <div
            id="gridSquareVisible-<%= square.id %>"
            class="
              <%= case square.path_type do
                :sharp_turn -> "bg-red-400"
                :straight -> "bg-green-400"
                _ -> "bg-yellow-400"
              end %>
              h-full rounded-sm bg-opacity-20 pointer-events-none
            "
          >
          </div>
        </button>
        <% end %>
      </div>
    </div>
    <svg
      id="svg_paths"
      class="absolute opacity-20"
      viewBox="0 0 <%= @mission.grid.width %> <%= @mission.grid.height %> "
      style="
        left: <%= @mission.margin.width %>px;
        top: <%= @mission.margin.height %>px;
        width:<%= @mission.grid.width %>px;
        height: <%= @mission.grid.height %>px
      "
    >
      <path
        id="lastPath"
        d="<%= @mission.unit.maneuver_svg_string %>"
        style="stroke-linejoin:round;stroke-width:20;stroke:#fff;fill:none"
      />
    </svg>
    <%= ChukinasWeb.DreadnoughtView.render "unit3.html",
      socket: @socket,
      unit: @mission.unit,
      margin: @mission.margin,
      game_over?: @mission.game_over? %>
    """
  end
  # TODO svg path as hook?

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("select_square", %{"x" =>  x, "y" => y, "type" => path_type}, socket) do
    path_type = path_type |> String.to_atom
    position = Position.new(String.to_float(x), String.to_float(y))
    mission =
      socket.assigns.mission
      |> Mission.move_unit_to(position, path_type)
      |> Mission.calc_game_over
    {:noreply, socket |> assign(mission: mission)}
  end

end
