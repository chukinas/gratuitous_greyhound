defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <p
      id="world"
      class="bg-blue-400"
      style="width:<%= @world.end_position.x - @world.start_position.x %>px; height: <%= @world.end_position.y - @world.start_position.y %>px"
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
