alias Chukinas.Dreadnought.Command
alias ChukinasWeb.Router.Helpers
defmodule ChukinasWeb.Dreadnought.CommandPanel do
  use Phoenix.LiveComponent

  # TODO delete templates/dreadnought/command.html.leex

  @impl true
  def render(assigns) do
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
            <%= command_card @socket, command %>
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

  def command_card(socket, %Command{} = command) do
    {angle, rudder_svg} = case Command.angle(command) do
      x when x > 0 -> {"#{x}°", "rudder_right.svg"}
      x when x < 0 -> {"#{-x}°", "rudder_left4.svg"}
      _ -> {"-", "rudder.svg"}
    end
    bg = case command.selected? do
      true -> "bg-yellow-600 outline-white"
      _ -> "bg-black bg-opacity-20"
    end
    assigns =
      command
      |> Map.from_struct
      |> Map.put(:speed_icon_path, Helpers.static_path(socket, "/images/propeller.svg"))
      |> Map.put(:angle_icon_path, Helpers.static_path(socket, "/images/#{rudder_svg}"))
      |> Map.put(:angle, angle)
      |> Map.put(:bg, bg)
    ~L"""
    <%# TODO this should be a button? %>
    <div
      id="command-<%= @id %>"
      class="h-16 w-16 grid grid-rows-2 grid-cols-2 gap-1 p-1 place-items-center cursor-pointer <%= @bg %>"
      data-selected="<%= @selected? %>"
      phx-click="select_command"
      phx-value-id="<%= @id %>"
    >
      <img class="w-full h-full" src="<%= @speed_icon_path %>">
      <div class="text-white text-xl font-bold text-center">
        <%= @len %>
      </div>
      <img class="w-full h-full" src="<%= @angle_icon_path %>">
      <div class="text-white text-xl font-bold text-center">
        <%= @angle %>
      </div>
    </div>
    """
  end
end
