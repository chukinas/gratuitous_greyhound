defmodule ChukinasWeb.Dreadnought.MenuBarComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div
      class="fixed inset-0  flex flex-col pointer-events-none text-yellow-500"
      x-data="{ tab: null }"
    >
      <div
        id="menuTabArea"
        class="bg-black bg-opacity-50 flex-grow flex items-center justify-center"
        x-bind:class="{ 'invisible': !tab }"
      >
        <%= if false do %>
        <div class="w-72 md:w-96 border-2 border-yellow-500 border-round my-4 p-4 overflow-auto">
          <%= ChukinasWeb.DreadnoughtView.render "welcome.html" %>
        </div>
        <button
          class="fixed top-2 left-2 p-4 pointer-events-auto font-bold uppercase rounded-full bg-yellow-500 text-xs text-black"
          @click=" tab = null "
        >
        </button>
        <% end %>
        <%= live_component @socket, ChukinasWeb.Dreadnought.FeedbackComponent, id: :feedback %>
        <button
          class="fixed top-0 right-0 p-4 pointer-events-auto font-bold uppercase"
          @click=" tab = null "
        >
          close
        </button>
      </div>
      <div
        id="menuBar"
        class=" bg-black bg-opacity-50 overflow-x-auto whitespace-nowrap flex space-x-4 pointer-events-auto"
      >
        <div class="flex-grow"></div>
        <%= for button <- @buttons do %>
        <button
          id="<%= button.id %>"
          class="py-1 border-transparent text-yellow-500 font-bold  hover:bg-yellow-500 hover:bg-opacity-20 border-b-8"
          <%= if button.hook do %>
            phx-hook="<%= button.hook %>"
          <% end %>
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
      %{id: "feedbackBtn", name: "Feedback", hook: nil, stateful?: true},
      # %{id: "about", name: "About", hook: "ButtonFitArena", stateful?: true},
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
