defmodule DreadnoughtWeb.DemoComponent do

  use DreadnoughtWeb, :live_component
  use Dreadnought.PositionOrientationSize

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
