defmodule ChukinasWeb.LobbyComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    IOP.inspect(assigns, "lobby comp, render")
    ~L"""
    <%= if @room do %>
      <div id="lobbyComponent">
        <p>Your room: <b><%= @room.pretty_name %></b></p>
      </div>
    <% end %>
    """
  end

end
