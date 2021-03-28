defmodule ChukinasWeb.Dreadnought.MenuBarComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div
      class="fixed inset-0  flex flex-col pointer-events-none"
    >
      <div
        id="menuTabArea"
        class="bg-black bg-opacity-0 flex-grow"
      >
      </div>
      <div
        id="menuBar"
        class=" bg-black bg-opacity-30 overflow-x-auto whitespace-nowrap flex space-x-4 pointer-events-auto"
        x-data="{ tab: null }"
      >
        <div class="flex-grow"></div>
        <%= for button <- @buttons do %>
        <button
          id="<%= button.id %>"
          class="py-1 border-transparent text-yellow-500 font-bold  hover:bg-yellow-500 hover:bg-opacity-20 border-b-8"
          phx-hook="<%= button.hook %>"
          <%= if button.stateful? do %>
          x-bind:class="{ 'border-current': tab === '<%= button.id %>'  }"
          @click="tab = '<%= button.id %>'"
          <% end %>
        >
          <%= button.name %>
        </button>
        <% end %>
        <div class="flex-grow relative">
          <div class="bg-green-400 absolute right-0 invisible text-xs">Force right-gap on last button. See link below.</div>
          <%# https://web.archive.org/web/20170707053030/http://www.brunildo.org/test/overscrollback.html %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    buttons = [
      %{id: "zoomIn", name: "Zoom In", hook: "ButtonZoomIn", stateful?: false},
      %{id: "zoomOut", name: "Zoom Out", hook: "ButtonZoomOut", stateful?: false},
      %{id: "center", name: "Center", hook: "ButtonFitArena", stateful?: false},
      %{id: "feedback", name: "Feedback", hook: "ButtonFitArena", stateful?: true},
      %{id: "about", name: "About", hook: "ButtonFitArena", stateful?: true},
    ]
    {:ok, assign(socket, buttons: buttons)}
  end

  # def button(name, hook) do
  #   assigns = %{name: name, hook: hook, __changed__: false}
  #   ~L"""
  #   <button class="py-1 text-yellow-500 font-bold border-b-4 border-yellow-500 hover:bg-yellow-500 hover:bg-opacity-20">
  #     <%= @name %>
  #   </button>
  #   """
  # end

end
