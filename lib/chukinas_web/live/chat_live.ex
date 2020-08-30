defmodule ChukinasWeb.ChatLive do
  use ChukinasWeb, :live_view
  # import Phoenix.HTML.Link
  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(params, _session, socket) do
    room_name = Map.get(params, "room_name", "")
    socket = assign(socket, :room_name, room_name)
    {:ok, socket}
  end

  # @impl true
  # def handle_event("uuid", uuid, socket) do
  #   IO.puts(uuid)
  #   {:noreply, assign(socket, uuid: uuid)}
  # end

  @impl true
  def handle_event("go_to_room", %{"room_name" => room_name}, socket) do
    # TODO downcase & slugify
    room_name = slugify(room_name)
    socket = assign(socket, :room_name, room_name)
    {:noreply, redirect(socket, to: "/chat/"<>room_name)}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  def slugify(string) do
    string = string
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
    IO.puts(string)
    string
  end
end

# TODO JJC
# git
# go back to lobby
# ensure links aren't establishing new socket
# formatter for templates
# remove the vscode scroll thumbnail
# remove keyboard layout shortcut
# formatting for vscode ~L sigil
# TODO aren't showing up highlighted
