defmodule DreadnoughtWeb.Dreadnought.PlayerTurnComponent do

  use DreadnoughtWeb, :live_component
  use DreadnoughtWeb.Components
  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.PlayerTurn
  alias Dreadnought.Missions
  alias Dreadnought.Util.Precision
  alias DreadnoughtWeb.PlayView, as: View

  def render(template, assigns), do: View.render(template, assigns)

  # TODO is it a problem that there isn't a single root element here? %>

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(id: assigns.id)
      |> assign_from_mission(assigns.mission, ~w/turn_number units name/a)
      |> assign(player_turn: PlayerTurn.new(assigns.mission, assigns.player_uuid))
      #|> assign_action_selection
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

  @impl true
  def handle_event("leave_game", _, socket) do
    socket
    |> player_uuid
    |> Missions.drop_player
    {:noreply, socket}
  end

  defp maybe_end_turn(socket) do
    if turn_complete?(socket) do
      socket
      |> name
      |> Missions.complete_player_turn(action_selection(socket))
    end
    socket
  end

  # *** *******************************
  # *** SOCKET REDUCERS

  defp assign_from_mission(socket, mission, mission_keys) do
    Enum.reduce(mission_keys, socket, fn key, socket ->
      value = Map.fetch!(mission, key)
      assign(socket, key, value)
    end)
  end

  #defp assign_action_selection(socket) do
  #  action_selection = socket |> player_turn |> PlayerTurn.action_selection
  #  current_action_selection = action_selection |> ActionSelection.current_action_selection
  #  socket
  #  |> assign(action_selection: action_selection)
  #  |> assign(current_action_selection: current_action_selection)
  #end

  # *** *******************************
  # *** SOCKET CONVERTERS

  def action_selection(socket), do: socket |> player_turn |> PlayerTurn.action_selection

  def player_id(socket), do: socket |> player_turn |> PlayerTurn.player_id

  def player_turn(socket), do: socket.assigns.player_turn

  def player_uuid(socket), do: socket |> player_turn |> PlayerTurn.player_uuid

  def name(socket), do: socket.assigns.name

  def turn_complete?(socket) do
    socket
    |> action_selection
    |> ActionSelection.turn_complete?
  end

end
