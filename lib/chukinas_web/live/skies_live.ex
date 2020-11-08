defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.{Game, ViewModel}

  #############################################################################
  # HELPERS
  #############################################################################

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(_params, _session, socket) do
    game = Game.init({1, "a"})
    socket =
      socket
      |> assign(:game, game)
      |> assign(:vm, ViewModel.build(game))
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
