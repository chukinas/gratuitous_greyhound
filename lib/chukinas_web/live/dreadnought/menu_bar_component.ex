defmodule ChukinasWeb.Dreadnought.MenuBarComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ChukinasWeb.DreadnoughtView.render "component_menu_bar.html", assigns
  end

  @impl true
  def mount(socket) do
    buttons = [
      %{id: "zoomIn", name: "Zoom In", hook: "ButtonZoomIn", stateful?: false},
      %{id: "zoomOut", name: "Zoom Out", hook: "ButtonZoomOut", stateful?: false},
      #%{id: "right", name: "Right", hook: "ButtonRight", stateful?: false},
      # %{id: "down", name: "Down", hook: "ButtonDown", stateful?: false},
      # %{id: "left", name: "Left", hook: "ButtonLeft", stateful?: false},
      # %{id: "up", name: "Up", hook: "ButtonUp", stateful?: false},
      %{id: "fullScreen", name: "View Map", hook: "ButtonFitArena", stateful?: false},
      #%{id: "feedbackBtn", name: "Feedback", hook: nil, stateful?: true},
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
