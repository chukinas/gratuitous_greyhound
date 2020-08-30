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
    {:noreply, redirect(socket, to: "/chat/"<>room_name)}
  end

  @impl true
  def handle_event("go_to_lobby", _params, socket) do
    {:noreply, redirect(socket, to: "/chat")}
  end

end

# TODO JJC
# use helpers instead of hard coding the links
#   lookup docs on live_path
# ensure links aren't establishing new socket
# formatter for templates
# remove the vscode scroll thumbnail
# remove keyboard layout shortcut
# formatting for vscode ~L sigil
# TODO aren't showing up highlighted
# TODO room name as value, not placeholder
# Where's the right place to put the plug?
# scope the plug to just one and chat
# should room_name be temp assigns?
# events: go to room or lobby: use helpers
