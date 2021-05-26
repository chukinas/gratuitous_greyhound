defmodule ChukinasWeb.LobbyComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="lobbyComponent">
      <p>Your room: <b><%= @user_session.pretty_room_name %></b></p>
    </div>
    """
  end

end
