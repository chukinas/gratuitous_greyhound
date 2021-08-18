defmodule DreadnoughtWeb.LobbyComponent do

  use DreadnoughtWeb, :live_component
  use DreadnoughtWeb.Components
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Missions

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(
    %{id: id} = assigns,
    socket) do
    mission = assigns.mission
    uuid = assigns.uuid
    player_self = Mission.player_by_uuid(mission, uuid)
    ready? = Player.ready? player_self
    socket =
      assign(socket,
        id: id,
        mission_name: Mission.name(mission),
        pretty_mission_name: Mission.pretty_name(mission),
        player_id: Player.id(player_self),
        uuid: uuid,
        players_text: (for player <- Mission.players_sorted(mission), do: build_player_text(player, uuid)),
        ready_button_text: (if ready?, do: "I'm not ready", else: "I'm ready")
      )
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_ready", _, socket) do
    Missions.toggle_ready(socket.assigns.mission_name, socket.assigns.player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("leave_mission", _, socket) do
    Missions.drop_player(socket.assigns.uuid)
    {:noreply, socket}
  end

  # *** *******************************
  # *** PRIVATE

  defp build_player_text(%Player{} = player, uuid) do
    [
      "Player #{player.id}: #{player.name}",
      (if player.ready?, do: " (ready)", else: ""),
      (if Player.uuid(player) == uuid, do: " (you)", else: "")
    ]
  end

end
