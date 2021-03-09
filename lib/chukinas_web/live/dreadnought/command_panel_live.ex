defmodule ChukinasWeb.Dreadnought.CommandPanel do
  use Phoenix.LiveComponent

  # TODO delete templates/dreadnought/command.html.leex

  @impl true
  def render(assigns) do
    assigns |> IOP.inspect("command panel assigns!")
    ~L"""
    <div class="bg-red-500 opacity-50 fixed inset-x-0 bottom-0">
      <div class="flex gap-4">
        <div class="flex-1"></div>
        <button class="p-2 text-white text-xl font-bold bg-black bg-opacity-20"><<</button>
        <button
          id="issueCommand"
          phx-hook="IssueCommand"
          class="p-2 text-white text-xl font-bold bg-black bg-opacity-20 disabled:opacity-25"
        >
          Issue Command
        </button>
        <button class="p-2 text-white text-xl font-bold bg-black bg-opacity-20">>></button>
        <div class="flex-1"></div>
      </div>
      <div class="flex">
        <div class="flex-1"></div>
        <div class="flex-1 order-3"></div>
        <div class="grid gap-4 p-4 grid-cols-4 justify-center ">
          <%= for command <- @commands do %>
            <%= ChukinasWeb.DreadnoughtView.command %{socket: @socket, command: command} %>
          <% end %>
        </div>
      </div>
    </div>
    """
#     ~L"""
#     <h1 class="m-4 text-lg">LiveComponent</h1>
#     <%= for item <- @num_list do %>
#       <button
#         phx-click="incr"
#         phx-target="<%= @myself %>"
#         class="cursor-pointer p-4 ml-4 bg-blue-400"
#         value="<%= item.id %>"
#       >
#         <%= item.val %>
#       </button>
#     <% end %>
#     <button
#       class="m-8 p-4 bg-red-300"
#       phx-click="save"
#       phx-target="<%= @myself %>"
#     >
#       Save
#     </button>
#     <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.6.0/gsap.min.js"></script>
#     """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  # @impl true
  # def handle_event("save", _, socket) do
  #   socket.assigns |> IOP.inspect
  #   send self(), {:updated_num_list, socket.assigns.num_list}
  #   {:noreply, socket}
  # end

  # @impl true
  # def handle_event("incr", %{"value" => id}, socket) do
  #   id = String.to_integer(id)
  #   num_list =
  #     socket.assigns.num_list
  #     |> Enum.map(fn item -> maybe_incr_val(item, id) end)
  #   {:noreply, socket |> assign(num_list: num_list)}
  # end

  # defp maybe_incr_val(%{id: id, val: val} = item, item_id) when id == item_id, do: %{ item | val: val + 1 }
  # defp maybe_incr_val(item, _id), do: item
end
