require IEx

defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.Maps

  #############################################################################
  # HELPERS
  #############################################################################


  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:map, Maps.map_grouped_by_rows())
    {:ok, socket}
  end

  # @impl y, socket}
  # endtrue
  # def handle_event("flip", _params, socket) do
  #   IO.inspect(socket, label: "flipping!")
  #   # TODO uuid
  #   state = API.flip(socket.assigns.state.name, 1)
  #   socket = assign(socket, :state, state)
  #   {:noreply, socket}
  # end

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
