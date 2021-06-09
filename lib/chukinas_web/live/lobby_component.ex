alias Chukinas.Dreadnought.Player
alias Chukinas.Sessions.{Room, User}

defmodule ChukinasWeb.LobbyComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    # TODO reduce the number of unnecessary incoming assigns
    user = assigns.user
    room = assigns.room
    players =
      if room do
        for player <- Room.players_sorted(room), do: build_player(player, user)
      else
        []
      end
    socket =
      assign(socket,
        pretty_room_name: Room.pretty_name(room),
        players: players
      )
    {:ok, socket}
  end

  # *** *******************************
  # *** FUNCTIONS

  def build_player(%Player{} = player, %User{} = user) do
    %{
      id: Player.id(player),
      name: Player.name(player),
      self?: Player.uuid(player) == User.uuid(user)
    }
  end

end
