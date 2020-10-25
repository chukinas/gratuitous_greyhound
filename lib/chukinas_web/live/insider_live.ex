require IEx

defmodule ChukinasWeb.InsiderLive do
  use ChukinasWeb, :live_view
  alias Chukinas.User
  # TODO remove
  alias Chukinas.Chat.Users
  alias Chukinas.Chat.Room
  alias Chukinas.Insider.Boundary.API

  #############################################################################
  # HELPERS
  #############################################################################

  def assign_user_and_room(socket, user, room) do
    socket
    |> assign(:user, user)
    |> assign(:room, room)
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(params, _session, socket) do
    room_name = Map.get(params, "room")
    IO.inspect(room_name, label: "Room Name")
    # TODO replace placeholder uuid
    game_state = API.get_state(room_name, 1)
    socket =
      socket
      |> assign(:state, game_state)
      |> assign(:msg_input_val, "")
    {:ok, socket}
  end

  @impl true
  def handle_event("flip", _params, socket) do
    IO.inspect(socket, label: "flipping!")
    # TODO uuid
    state = API.flip(socket.assigns.state.name, 1)
    socket = assign(socket, :state, state)
    {:noreply, socket}
  end

  @impl true
  def handle_event("change_user_name", %{"user_name" => user_name}, socket) do
    user = Map.put(socket.assigns.user, :name, user_name)
    Room.upsert_user(socket.assigns.room.name, user)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:state_update, user, room}, socket) do
    socket = assign_user_and_room(socket, user, room)

    {:noreply, socket}
  end
end
