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
    {_, changeset} = params |> UserSession.changeset
    socket = assign_changeset_and_url(socket, changeset)
    {:noreply, socket}
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
        socket = assign_changeset_and_url(socket, changeset)
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :insert))}
    end
  end

  def assign_changeset_and_url(socket, changeset, show_errors? \\ true) do
    changeset = if show_errors?, do: Map.put(changeset, :action, :insert), else: changeset
    room_slug = UserSession.get_room_slug(changeset)
    url = [
      URI.to_string(socket.host_uri),
      "dreadnought/play",
      room_slug
    ]
    |> Enum.join("/")
    |> IOP.inspect("join room url")
    assign(socket, maybe_url: url, changeset: changeset)
  end

  @impl true
  def update(assigns, socket) do
    {_, changeset} = UserSession.empty()
    socket =
      socket
      |> assign(assigns)
      |> assign_changeset_and_url(changeset, false)
    {:ok, socket}
  end

end
