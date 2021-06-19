defmodule ChukinasWeb.Dreadnought.DynamicWorldComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Util.Precision

  @impl true
  def render(assigns) do
    # TODO is it a problem that there isn't a single root element here? %>
    # TODO might be worth having a containing div so I only have to set margin and size once
    ChukinasWeb.DreadnoughtView.render("component_dynamic_world.html", assigns)
  end

  @impl true
  # the assigns are a map of Mission.Player
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
    {:ok, socket}
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("select_gunnery_target", %{
    "unit_id" => unit_id,
  }, socket) do
    player_actions =
      socket.assigns.player_actions
      |> ActionSelection.select_gunnery_target(Precision.coerce_int(unit_id))
      |> maybe_end_turn
    socket =
      socket
      |> assign(player_actions: player_actions)
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_square", %{
    "unit_id" => unit_id,
    "x" =>  x,
    "y" => y
  }, socket) do
    [x, y, unit_id] =
      [x, y, unit_id]
      |> Precision.coerce_int
    player_actions =
      socket.assigns.player_actions
      |> ActionSelection.maneuver(unit_id, x, y)
      |> maybe_end_turn
    socket =
      socket
      |> assign(player_actions: player_actions)
    {:noreply, socket}
  end

  @impl true
  def handle_event("end_turn", _, socket) do
    maybe_end_turn(socket.assigns.player_actions)
    {:noreply, socket}
  end

  defp maybe_end_turn(%ActionSelection{} = player_actions) do
    if ActionSelection.turn_complete?(player_actions) do
      send self(), {:player_turn_complete, player_actions}
    end
    player_actions
  end

  #def inspect_assigns(assigns, note) do
  #  mod_assigns =Map.drop assigns, [:socket, :flash, :grid, :id, :margin, :myself]
  #  assigns
  #end

end
