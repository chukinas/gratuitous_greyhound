defmodule ChukinasWeb.LobbyComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions
  alias Chukinas.Sessions.Missions

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(assigns, socket) do
    mission = assigns.mission
    uuid = assigns.uuid
    player_self = Mission.player_by_uuid(mission, uuid)
    ready? = Player.ready? player_self
    socket =
      assign(socket,
        room_name: Mission.name(mission),
        pretty_room_name: Mission.pretty_name(mission),
        player_id: Player.id(player_self),
        uuid: uuid,
        players_text: (for player <- Mission.players_sorted(mission), do: build_player_text(player, uuid)),
        ready_button_text: (if ready?, do: "I'm not ready", else: "I'm ready")
      )
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_ready", _, socket) do
    Missions.toggle_ready(socket.assigns.room_name, socket.assigns.player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("leave_room", _, socket) do
    Sessions.leave_room(socket.assigns.uuid)
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
