require IEx

defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.Spaces

  #############################################################################
  # HELPERS
  #############################################################################

  def render_size() do
    {x, y} = Spaces.build_map_spec()
    |> Spaces.get_size()
    "{#{x}, #{y}}"
  end

  def render_grid() do
    Spaces.build_map_spec()
    |> Spaces.render_grid()
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:map, render_grid())
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
