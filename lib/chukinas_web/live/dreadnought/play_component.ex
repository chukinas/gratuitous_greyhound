alias ChukinasWeb.Dreadnought.{PlayComponent}
alias Chukinas.Sessions

# TODO rename RoomComponent
defmodule PlayComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    # TODO remove the setting of user_session to nil in liveview
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
    # TODO take this away once I have a lobby component
      |> assign(pretty_room_name: Sessions.pretty_room_name(assigns.user_session))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= if assigns.show_join_screen? do %>
      <%= live_component(
            @socket,
            ChukinasWeb.JoinComponent,
            id: :join_room,
            path_params: @path_params,
            user_session: @user_session )%>
    <% else %>
      <p>Your room: <b><%= @pretty_room_name %></b></p>
    <% end %>
    """
  end

end
