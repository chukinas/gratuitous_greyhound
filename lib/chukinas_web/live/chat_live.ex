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

# TODO JJC
# formatter for templates
# remove the vscode scroll thumbnail
# remove keyboard layout shortcut
# formatting for vscode ~L sigil
# TODO aren't showing up highlighted
# TODO room name as value, not placeholder
# Where's the right place to put the plug?
# scope the plug to just one and chat
# should room_name be temp assigns?
# check for todos
