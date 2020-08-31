defmodule ChukinasWeb.ChatLive do
  use ChukinasWeb, :live_view

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(params, _session, socket) do
    room_name = Map.get(params, "room_name", "")
    socket = assign(socket, :room_name, room_name)
    {:ok, socket}
  end

  @impl true
  def handle_event("go_to_room", %{"room_name" => room_name}, socket) do
    path = Routes.chat_path(socket, :show, room_name)
    {:noreply, redirect(socket, to: path)}
  end

  @impl true
  def handle_event("go_to_lobby", _params, socket) do
    path = Routes.chat_path(socket, :index)
    {:noreply, redirect(socket, to: path)}
  end
end

# TODO
# Dynamic Room Supervisor
# handle call: add room
# handle call: remove room
# handle call: show rooms

# TODO
# remove the auto counter
# going to a liveview page should call a method on the Rooms context
# the genserver then adds that room to its state and prints its state

# TODO
# put a timestamp on the room name
# emit timed event
