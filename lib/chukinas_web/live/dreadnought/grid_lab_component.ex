defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <p
      id="world"
      class="bg-blue-400"
      style="width:<%= @world.width %>px; height: <%= @world.height %>px"
    >
      WORLD
    </p>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

end
