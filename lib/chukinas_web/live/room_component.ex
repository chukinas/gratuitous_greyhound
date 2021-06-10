alias Chukinas.Sessions

defmodule ChukinasWeb.RoomComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    show_join_screen? =
      cond do
        assigns.show_join_screen? -> true
        is_struct(assigns.user_session, Sessions.UserSession) -> false
        true -> true
      end
    socket =
      socket
      |> assign(assigns)
      |> assign(show_join_screen?: show_join_screen?)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="roomComponent">
      <%= if assigns.show_join_screen? do %>
        <%= live_component(
              @socket,
              ChukinasWeb.JoinComponent,
              id: :join,
              path_params: @path_params,
              user: @user,
              user_session: @user_session )%>
      <% else %>
        <%= live_component(
              @socket,
              ChukinasWeb.LobbyComponent,
              id: :lobby,
              room: @room,
              user: @user,
              user_session: @user_session )%>
      <% end %>
    </div>
    """
  end

end
