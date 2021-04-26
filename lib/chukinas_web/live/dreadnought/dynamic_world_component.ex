alias Chukinas.Dreadnought.{ActionSelection}
alias Chukinas.Util.Precision

defmodule ChukinasWeb.Dreadnought.DynamicWorldComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    #inspect_assigns assigns, "render assigns"
    # TODO is it a problem that there isn't a single root element here? %>
    # TODO might be worth having a containing div so I only have to set margin and size once
    ~L"""
    <div id="turn-number" data-turn-number="<%= @turn_number %>" phx-hook="TurnNumber"></div>
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
        <%= for unit <- @units do %>
        <%= if unit.id in @action_selection.active_unit_ids do %>
        <%= for square <- unit.cmd_squares do %>
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
          phx-value-unit_id="<%= unit.id %>"
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
        <% end %>
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
      <%= for unit <- @units do %>
      <path
        id="unit-<%= unit.id %>-lastPath"
        d="<%= unit.maneuver_svg_string %>"
        style="stroke-linejoin:round;stroke-width:20;stroke:#fff;fill:none"
      />
      <% end %>
    </svg>
    <%= for unit <- @units do %>
    <%= ChukinasWeb.DreadnoughtView.render "unit3.html",
      socket: @socket,
      unit: unit,
      margin: @margin %>
    <% end %>
    """
  end

  @impl true
  # the assigns are a map of Mission.Player
  def update(assigns, socket) do
    #IOP.inspect(assigns, "update dyn comp")
    #inspect_assigns assigns, "update dyn comp!"
    IOP.inspect(assigns.turn_number, "new turn")
    socket =
      socket
      |> assign(assigns)
    maybe_end_turn(assigns.action_selection)
    {:ok, socket}
  end

  @impl true
  def mount(socket) do
    #inspect_assigns socket.assigns, "mount dyn comp!"
    {:ok, socket}
  end

  @impl true
  def handle_event("select_square", %{
    "x" =>  x,
    "y" => y,
    "unit_id" => unit_id
  }, socket) do
    [x, y, unit_id] =
      [x, y, unit_id]
      # TODO coerce int should accept list as well
      |> Enum.map(&Precision.coerce_int/1)
    action_selection =
      socket.assigns.action_selection
      |> ActionSelection.maneuver(unit_id, x, y)
      |> maybe_end_turn
    socket =
      socket
      |> assign(action_selection: action_selection)
    {:noreply, socket}
  end

  defp maybe_end_turn(%ActionSelection{} = action_selection) do
    IO.puts "maybe end turn"
    if ActionSelection.turn_complete?(action_selection) do
      IO.puts "yes, end turn"
      send self(), {:player_turn_complete, action_selection}
    end
    action_selection
  end

  #def inspect_assigns(assigns, note) do
  #  mod_assigns =Map.drop assigns, [:socket, :flash, :grid, :id, :margin, :myself]
  #  #IOP.inspect mod_assigns, note
  #  assigns
  #end

end
