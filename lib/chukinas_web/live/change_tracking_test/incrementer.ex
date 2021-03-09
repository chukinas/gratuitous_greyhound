defmodule IncrementerComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="m-4 text-lg">LiveComponent</h1>
    <%= for item <- @num_list do %>
      <button
        phx-click="incr"
        phx-target="<%= @myself %>"
        class="cursor-pointer p-4 ml-4 bg-blue-400"
        value="<%= item.id %>"
      >
        <%= item.val %>
      </button>
    <% end %>
    <button
      class="m-8 p-4 bg-red-300"
      phx-click="save"
      phx-target="<%= @myself %>"
    >
      Save
    </button>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.6.0/gsap.min.js"></script>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("save", _, socket) do
    socket.assigns |> IOP.inspect
    send self(), {:updated_num_list, socket.assigns.num_list}
    {:noreply, socket}
  end

  @impl true
  def handle_event("incr", %{"value" => id}, socket) do
    id = String.to_integer(id)
    num_list =
      socket.assigns.num_list
      |> Enum.map(fn item -> maybe_incr_val(item, id) end)
    {:noreply, socket |> assign(num_list: num_list)}
  end

  defp maybe_incr_val(%{id: id, val: val} = item, item_id) when id == item_id, do: %{ item | val: val + 1 }
  defp maybe_incr_val(item, _id), do: item
end
