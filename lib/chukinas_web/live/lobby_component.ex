defmodule ChukinasWeb.LobbyComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.Rooms

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(assigns, socket) do
    room = assigns.room
    uuid = assigns.uuid
    player_self = Room.player_from_uuid(room, uuid)
    ready? = Player.ready? player_self
    socket =
      assign(socket,
        room_name: Room.name(room),
        pretty_room_name: Room.pretty_name(room),
        player_id: Player.id(player_self),
        uuid: uuid,
        players_text: (for player <- Room.players_sorted(room), do: build_player_text(player, uuid)),
        ready_button_text: (if ready?, do: "I'm not ready", else: "I'm ready")
      )
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_ready", _, socket) do
    Rooms.toggle_ready(socket.assigns.room_name, socket.assigns.player_id)
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
      (if Player.uuid(player) == uuid, do: " (self)", else: "")
    ]
  end

end
