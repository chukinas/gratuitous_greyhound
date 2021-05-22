alias ChukinasWeb.Dreadnought.{JoinRoomComponent}
alias Chukinas.Dreadnought.{UserSession}

defmodule JoinRoomComponent do
  use ChukinasWeb, :live_component
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    IOP.inspect params, "join room validate"
    changeset =
      params
      |> UserSession.changeset
      |> Map.put(:action, :insert)
      |> IOP.inspect
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user_session" => params}, socket) do
    changeset =
      params
      |> UserSession.changeset
      |> IOP.inspect
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: UserSession.empty())
      |> IOP.inspect("join room update")
    {:ok, socket}
  end

  # TODO put the aria and placeholder stuff back in
  @impl true
  def render(assigns) do
    ChukinasWeb.DreadnoughtView.render("component_join_room.html", assigns)
  end

end
