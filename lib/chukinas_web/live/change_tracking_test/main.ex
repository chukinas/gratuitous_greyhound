defmodule ChukinasWeb.ChangeTrackingTestLive do
  use ChukinasWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="m-4 text-lg">Master List</h1>
    <%= for item <- @num_list do %>
      <p class="m-4">
        <%= item.id %>: <%= item.val %>
      </p>
    <% end %>
    <button
      class="m-4 p-4 bg-red-300"
      phx-click="reset"
    >
      Reset LiveComponent
    </button>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.6.0/gsap.min.js"></script>
    <%= live_component(@socket, IncrementerComponent, id: :incr, num_list: @num_list) %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Change Tracking Test!")
      |> assign(num_list: build_numbers_list(), id: 1)
    {:ok, socket}
  end

  @impl true
  def handle_event("reset", _, socket) do
    socket |> IOP.inspect
    send_update(IncrementerComponent, id: :incr, num_list: socket.assigns.num_list)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:updated_num_list, num_list}, socket) do
    {:noreply, socket |> assign(num_list: num_list)}
  end

  defp build_numbers_list() do
    1..5
    |> Enum.map(&(%{id: &1, val: &1}))
  end
end
