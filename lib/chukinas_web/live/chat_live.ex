defmodule ChukinasWeb.ChatLive do
  use ChukinasWeb, :live_view

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("go_to_room", %{"room_name" => room_name}, socket) do
    path = Routes.chat_room_path(socket, :show, room_name)
    {:noreply, redirect(socket, to: path)}
  end

end
