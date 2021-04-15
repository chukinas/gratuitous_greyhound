alias Chukinas.Dreadnought.{Mission}
alias Chukinas.Geometry.{Position}
alias Chukinas.Util.Precision

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
        <%= for square <- @mission_player.current_unit.cmd_squares do %>
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
          <%# TODO 185 dynamically generate this id %>
          phx-value-unit_id=1
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
      viewBox="0 0 <%= @grid.width %> <%= @grid.height %> "
      style="
        left: <%= @margin.width %>px;
        top: <%= @margin.height %>px;
        width:<%= @grid.width %>px;
        height: <%= @grid.height %>px
      "
    >
      <%= for unit <- @mission_player.my_other_units do %>
      <path
        id="unit-<%= unit.id %>-lastPath"
        d="<%= unit.maneuver_svg_string %>"
        style="stroke-linejoin:round;stroke-width:20;stroke:#fff;fill:none"
      />
      <% end %>
    </svg>
    <%= for unit <- @mission_player.my_other_units do %>
    <%= ChukinasWeb.DreadnoughtView.render "unit3.html",
      socket: @socket,
      unit: unit,
      margin: @margin %>
    <% end %>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("select_square", %{"x" =>  x, "y" => y, "type" => path_type, "unit_id" => unit_id}, socket) do
    path_type = path_type |> String.to_atom
    [x, y, id] =
      [x, y, unit_id]
      |> Enum.map(&Precision.coerce_int/1)
    position = Position.new(x, y)
    mission =
      socket.assigns.mission
      |> Mission.move_unit_to(id, position, path_type)
    {:noreply, socket |> assign(mission: mission)}
  end

end
