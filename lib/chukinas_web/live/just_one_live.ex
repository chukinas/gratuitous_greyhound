defmodule ChukinasWeb.JustOneLive do
  use ChukinasWeb, :live_view

  #############################################################################
  # HELPERS
  #############################################################################

  defp assign_tentative_uuid(socket) do
    # saved to localstorage if one doesn't already exist
    assign(socket, :uuid, UUID.uuid4())
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  def mount(%{"room" => room}, _session, socket) do
    socket =
      socket
      |> assign_tentative_uuid
      |> assign(:room, room)
    socket |> inspect |> IO.puts()
    {:ok, socket}
  end

  @impl true
  def mount(_params, session, socket) do
    mount(%{"room" => ""}, session, socket)
  end

  @impl true
  def handle_event("uuid", uuid, socket) do
    IO.puts(uuid)
    {:noreply, assign(socket, uuid: uuid)}
  end

  # @impl true
  # def handle_event("go_to_room", %{"room_name" => room_name}, socket) do
  # # def handle_event("go_to_room", _, socket) do
  #   IO.puts("Go to room #{room_name}!")
  #   IO.puts(just_one_index_path(@socket, :index))
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event("go_to_room", _, socket) do
    IO.puts("Go to room! But which?")
    {:noreply, socket}
  end
end
