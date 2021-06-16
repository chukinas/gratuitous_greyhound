defmodule ChukinasWeb.LobbyComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.Room

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(assigns, socket) do
    room = assigns.room
    players = for player <- Room.players_sorted(room), do: build_player(player, assigns.uuid)
    socket =
      assign(socket,
        pretty_room_name: Room.pretty_name(room),
        players: players
      )
    {:ok, socket}
  end

  # *** *******************************
  # *** PRIVATE

  defp build_player(%Player{} = player, uuid) do
    player
    |> Map.from_struct
    |> Map.take(~w/id name ready?/a)
    |> Map.put(:self?, Player.uuid(player) == uuid)
  end

end
