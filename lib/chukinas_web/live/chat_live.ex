defmodule ChukinasWeb.ChatLive do
  use ChukinasWeb, :live_view

  #############################################################################
  # HELPERS
  #############################################################################

  def upsert_user(user_list, { new_pid, _user_name } = new_user) do
    user_list
    |> Enum.filter(fn {pid, _user_name} -> pid != new_pid end)
    |> (fn users -> [new_user | users] end).()
    # |> (&[new_user | &1]) TODO try to make this work
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(params, _session, socket) do
    room_name = Map.get(params, "room_name", "")
    socket =
      socket
      |> assign(:room_name, room_name)
      |> assign(:user_name, "<unknown>")
      |> assign(:user_list, [])
      |> assign(:messages, [])
      |> assign(:new_msg, "")
    {:ok, socket}
  end

  @impl true
  def handle_event("change_user_name", %{"user_name" => user_name}, socket) do
    socket =
      socket
      |> assign(:user_name, user_name)

    new_user = {self(), user_name}
    user_list = upsert_user(socket.assigns.user_list, new_user)
    send(self(), {:update_user_list, user_list})
    {:noreply, socket}
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

  @impl true
  def handle_event("new_msg", %{"msg" => msg}, socket) do
    send(self(), {:new_msg, msg})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_msg, msg}, socket) do
    socket =
      socket
      |> assign(:new_msg, "")
      |> update(:messages, &(&1 ++ [msg]))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_user_list, user_list}, socket) do
    socket =
      socket
      |> assign(:user_list, user_list)
    {:noreply, socket}
  end
end

# TODO
# LiveView
#   show pid
#   name text box
#   default user name, user pid to assigns
#   handle_info: update_user_list
#   handle_event: change_name
# Chat room supervisor
# GenServer API:
#   upsert_user (pid, name), updates the

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
