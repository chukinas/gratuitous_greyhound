# TODO Mission.add_player should not add duplicate uuids
# TODO Mission struct should have min_player_count
# TODO Mission.add_player should check to start mission if min_player_count is met?

defmodule DreadnoughtWeb.DemoComponent do

    use DreadnoughtWeb, :live_component
    use Dreadnought.PositionOrientationSize
  alias Dreadnought.Demo

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{id: id, uuid: uuid}, socket) do
    Demo.start(uuid)
    socket =
      socket
      |> assign(id: id)
      |> assign(uuid: uuid)
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
