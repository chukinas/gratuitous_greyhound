alias ChukinasWeb.Dreadnought.{JoinRoomComponent}
alias Chukinas.Dreadnought.{UserSession}

defmodule JoinRoomComponent do
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    IOP.inspect socket.conn_info, "hangle event val"
    {_, changeset} = params |> UserSession.changeset
    changeset = changeset |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user_session" => params}, socket) do
    case UserSession.changeset(params) do
      {:ok, changeset} ->
        user_session = changeset |> UserSession.apply
        socket =
          socket
          |> assign(username: user_session.username)
          |> push_patch(to: "/dreadnought/play/#{user_session.room_slug}")
        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :insert))}
    end
  end

  def assign_potential_url(socket, changeset) do
    assign(socket, :maybe_url, UserSession.maybe_url(changeset))
  end

  @impl true
  def update(assigns, socket) do
    {_, changeset} = UserSession.empty()
    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: changeset)
    {:ok, socket}
  end

end
