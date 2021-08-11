defmodule ChukinasWeb.DemoComponent do

  use ChukinasWeb, :live_component
  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id=<%= @id %>></div>
    """
  end

  # *** *******************************
  # *** HELPERS

end
