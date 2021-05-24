alias ChukinasWeb.Dreadnought.{PlayComponent}
alias Chukinas.Sessions

defmodule PlayComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {_, changeset} = Sessions.changeset_user_session(assigns.user_session, %{})
    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(user_session: Sessions.apply_changes(changeset))
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @changeset.valid? do %>
      <p>Your room: <b><%= @user_session.room_name %></b></p>
    <% else %>
      <%= live_component @socket, ChukinasWeb.Dreadnought.JoinRoomComponent, id: :join_room, changeset: @changeset %>
    <% end %>
    """
  end

end
