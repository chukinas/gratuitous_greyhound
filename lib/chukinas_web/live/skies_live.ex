require IEx

defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.Spaces

  #############################################################################
  # HELPERS
  #############################################################################

  def render_spaces() do
    Spaces.get_formation({1, "a"}).spaces
    |> Spaces.render_spaces()
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:map, render_spaces())
    {:ok, socket}
  end

  @impl true
  def handle_event("select_space", %{"x" => x, "y" => y}, socket) do
    IO.puts("selected a space: {#{x}, #{y}}")
    {:noreply, socket}
  end

  # @impl true
  # def handle_event("change_user_name", %{"user_name" => user_name}, socket) do
  #   user = Map.put(socket.assigns.user, :name, user_name)
  #   Room.upsert_user(socket.assigns.room.name, user)
  #   {:noreply, socket}
  # end

  # @impl true
  # def handle_info({:state_update, user, room}, socket) do
  #   socket = assign_user_and_room(socket, user, room)

  #   {:norepl
end
