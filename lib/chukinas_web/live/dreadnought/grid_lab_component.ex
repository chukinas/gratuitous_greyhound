defmodule ChukinasWeb.Dreadnought.GridLabComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <p class="bg-blue-400">hello</p>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

end
