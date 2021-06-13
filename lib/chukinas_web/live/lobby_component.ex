alias Chukinas.Dreadnought.Player
alias Chukinas.Sessions.Room
alias ChukinasWeb.Components

defmodule ChukinasWeb.LobbyComponent do
  use ChukinasWeb, :live_component
  use Components

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
  # *** FUNCTIONS

  def build_player(%Player{} = player, uuid) do
    %{
      id: Player.id(player),
      name: Player.name(player),
      self?: Player.uuid(player) == uuid
    }
  end

end
