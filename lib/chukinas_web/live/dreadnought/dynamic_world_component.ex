alias Chukinas.Dreadnought.{PlayerActions}
alias Chukinas.Util.Precision

defmodule ChukinasWeb.Dreadnought.DynamicWorldComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    # TODO is it a problem that there isn't a single root element here? %>
    # TODO might be worth having a containing div so I only have to set margin and size once
    ChukinasWeb.DreadnoughtView.render("component_dynamic_world.html", assigns)
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
    maybe_end_turn(assigns.player_actions)
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
    player_actions =
      socket.assigns.player_actions
      |> PlayerActions.maneuver(unit_id, x, y)
      |> maybe_end_turn
    socket =
      socket
      |> assign(player_actions: player_actions)
    {:noreply, socket}
  end

  defp maybe_end_turn(%PlayerActions{} = player_actions) do
    IO.puts "maybe end turn"
    if PlayerActions.turn_complete?(player_actions) do
      IO.puts "yes, end turn"
      send self(), {:player_turn_complete, player_actions}
    end
    player_actions
  end

  #def inspect_assigns(assigns, note) do
  #  mod_assigns =Map.drop assigns, [:socket, :flash, :grid, :id, :margin, :myself]
  #  #IOP.inspect mod_assigns, note
  #  assigns
  #end

end
