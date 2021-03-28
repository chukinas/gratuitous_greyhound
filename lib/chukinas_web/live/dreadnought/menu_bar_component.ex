defmodule ChukinasWeb.Dreadnought.MenuBarComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed inset-x-0 bottom-0 bg-black bg-opacity-30 overflow-x-auto whitespace-nowrap flex space-x-4 pb-2">
      <div class="flex-grow"></div>
      <%= for button <- @buttons do %>
      <button
        id="<%= button.id %>"
        class="py-1 text-yellow-500 font-bold border-b-4 border-yellow-500 hover:bg-yellow-500 hover:bg-opacity-20"
        phx-hook="<%= button.hook %>"
      >
        <%= button.name %>
      </button>
      <% end %>
      <div class="flex-grow relative">
        <div class="bg-green-400 absolute right-0 invisible text-xs">Force right-gap on last button. See link below.</div>
        <%# https://web.archive.org/web/20170707053030/http://www.brunildo.org/test/overscrollback.html %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    buttons = [
      %{id: "zoomIn", name: "Zoom In", hook: "ButtonZoomIn"},
      %{id: "zoomOut", name: "Zoom Out", hook: "ButtonZoomOut"},
      %{id: "center", name: "Center", hook: "ButtonFitArena"},
      %{id: "feedback", name: "Feedback", hook: "ButtonFitArena"},
      %{id: "about", name: "About", hook: "ButtonFitArena"},
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
