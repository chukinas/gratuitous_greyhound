defmodule ChukinasWeb.Dreadnought.PlayerTurnComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Dreadnought.PlayerTurn
  alias Chukinas.Util.Precision
  alias ChukinasWeb.DreadnoughtPlayView, as: View

  def render(template, assigns), do: View.render(template, assigns)

  # TODO is it a problem that there isn't a single root element here? %>

  @impl true
  # the assigns are a map of Mission.Player
  def update(assigns, socket) do
    socket =
      socket
      |> assign(id: assigns.id)
      |> assign(player_turn: assigns.mission_player)
      |> assign(turn_number: assigns.mission.turn_number)
      |> assign(grid: assigns.mission.grid)
      |> assign(units: assigns.mission.units)
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
    IOP.inspect unit_id, "this should be an integer"
    update_player_turn = &ActionSelection.select_gunnery_target(&1, Precision.coerce_int(unit_id))
    socket =
      socket
      |> update(:player_turn, update_player_turn)
      |> maybe_end_turn
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_square", %{
    "unit_id" => unit_id,
    "x" => x,
    "y" => y
  }, socket) do
    [x, y, unit_id] =
      [x, y, unit_id]
      |> Precision.coerce_int
    update_player_turn = fn player_turn ->
      action_update = &ActionSelection.maneuver(&1, unit_id, x, y)
      PlayerTurn.update_action_selection(player_turn, action_update)
    end
    socket =
      socket
      |> update(:player_turn, update_player_turn)
      |> maybe_end_turn
    {:noreply, socket}
  end

  @impl true
  def handle_event("end_turn", _, socket) do
    {:noreply, socket |> maybe_end_turn}
  end

  defp maybe_end_turn(%Phoenix.LiveView.Socket{} = socket) do
    maybe_end_turn(socket.assigns.player_turn.player_actions)
    socket
  end

  defp maybe_end_turn(%ActionSelection{} = player_actions) do
    IOP.inspect player_actions, "DynamicWorldComponent maybe_end_turn"
    IOP.inspect self(), "DynamicWorldComponent maybe_end_turn"
    # TODO make sure DreadnoughtLive doesn't have a handler for this
    if ActionSelection.turn_complete?(player_actions) do
      # Missions.complete_player_turn("the-red", player_actions)
      send self(), {:complete_turn, player_actions}
    end
    player_actions
    |> IOP.inspect("DynamicWorldComponent maybe_end_turn end")
  end

end
