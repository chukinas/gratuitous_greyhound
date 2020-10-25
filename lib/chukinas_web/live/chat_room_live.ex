require IEx

defmodule ChukinasWeb.JustOneLive do
  use ChukinasWeb, :live_view
  alias Chukinas.User
  alias Chukinas.Chat.Users
  alias Chukinas.Chat.Room

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
    room_name = Map.get(params, "room_name", "")
    room = %Room{name: room_name}
    user = User.new(self())
    Room.upsert_user(room_name, user)
    socket =
      socket
      |> assign_user_and_room(user, room)
      |> assign(:msg_input_val, "")

    {:ok, socket}
  end

  @impl true
  def handle_event("change_user_name", %{"user_name" => user_name}, socket) do
    user = Map.put(socket.assigns.user, :name, user_name)
    Room.upsert_user(socket.assigns.room.name, user)
    {:noreply, socket}
  end

  @impl true
  def handle_event("go_to_room", %{"room_name" => room_name}, socket) do
    path = Routes.chat_room_path(socket, :show, room_name)
    {:noreply, redirect(socket, to: path)}
  end

  @impl true
  def handle_event("go_to_lobby", _params, socket) do
    path = Routes.chat_path(socket, :index)
    {:noreply, redirect(socket, to: path)}
  end

  @impl true
  def handle_event("add_msg", %{"msg" => msg}, socket) do
    socket.assigns.room.name
    |> Room.add_msg(msg)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:state_update, user, room}, socket) do
    socket = assign_user_and_room(socket, user, room)

    {:noreply, socket}
  end
end

# TODO
# Room supervisor
# move user supervisor to chat supervisor

# TODO
# GENSERVER THAT REFLECTS MESSAGES BACK TO LIVEVIEW PROCESS
# Part 1: synchronous
# Genserver
#   add as child to top supervisor
# LiveView:
#   handle_info

# TODO
# GENSERVER THAT REFLECTS MESSAGES BACK TO LIVEVIEW PROCESS
# Part 2: asynchronous
# Genserver
#   handle_cast? Or handle_call that returns just a confirmation :ok?
#     either way, it doesn't send the value back. That's done with messaging.
# LiveView:
#   handle_info

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

# TODO
# superv tree: add supervisor for chat app
#   superv's a superv (a registry) for all the chat rooms
#   superv for chat room users

# TODO move room/lobby links to template
