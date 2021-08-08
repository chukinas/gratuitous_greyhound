defmodule ChukinasWeb.LobbyComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.Rooms

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(assigns, socket) do
    room = assigns.room
    uuid = assigns.uuid
    players = for player <- Room.players_sorted(room), do: build_player(player, uuid)
    player_self = Room.player_from_uuid(room, uuid)
    ready? = Player.ready? player_self
    socket =
      assign(socket,
        room_name: Room.name(room),
        pretty_room_name: Room.pretty_name(room),
        player_id: Player.id(player_self),
        ready?: ready?,
        ready_button_text: (if ready?, do: "I'm not ready", else: "I'm ready"),
        players: players,
        players_text: (for player <- Room.players_sorted(room), do: build_player_text(player))
      )
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_ready", _, socket) do
    Rooms.toggle_ready(socket.assigns.room_name, socket.assigns.player_id)
    {:noreply, socket}
  end

  # *** *******************************
  # *** PRIVATE

  defp build_player(%Player{} = player, uuid) do
    player
    |> Map.from_struct
    |> Map.take(~w/id name ready?/a)
    |> Map.put(:self?, Player.uuid(player) == uuid)
  end

  defp build_player_text(%Player{} = player) do
    [
      "Player #{player.id}: #{player.name}",
      (if player.ready?, do: " (ready)", else: "")
      #(if player.self?, do: " (self)")
    ]
  end

end
