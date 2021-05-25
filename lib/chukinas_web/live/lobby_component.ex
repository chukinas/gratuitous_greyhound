alias Chukinas.Sessions

defmodule ChukinasWeb.LobbyComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(pretty_room_name: Sessions.pretty_room_name(assigns.user_session))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <p>Your room: <b><%= @pretty_room_name %></b></p>
    """
  end

end
