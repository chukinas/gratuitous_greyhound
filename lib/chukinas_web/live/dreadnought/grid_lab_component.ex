defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div
      id="world"
      class="bg-blue-400 relative"
      style="width:<%= @world.width %>px; height: <%= @world.height %>px"
    >
      WORLD
      <div
        id="arena"
        class="bg-green-300 absolute"
        style="
          left: 500px;
          top: 500px;
          width:500px;
          height: 500px
        "
      >
      ARENA
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

end
