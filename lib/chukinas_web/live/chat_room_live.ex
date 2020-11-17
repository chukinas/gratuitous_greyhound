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
