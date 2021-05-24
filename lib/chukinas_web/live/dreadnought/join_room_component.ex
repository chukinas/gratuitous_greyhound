alias ChukinasWeb.Dreadnought.{JoinRoomComponent}
alias Chukinas.Sessions

defmodule JoinRoomComponent do
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_changeset_and_url(assigns.changeset, false)
      |> maybe_redirect_away_from_room
    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    {_, changeset} = params |> Sessions.changeset_user_session
    socket = assign_changeset_and_url(socket, changeset)
    {:noreply, socket}
  end

  # TODO rename "join"
  def handle_event("save", %{"user_session" => params}, socket) do
    case Sessions.change_user_session(params) do
      {:ok, changeset} ->
        user_session = changeset |> Sessions.apply_changes
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
    room_slug = Sessions.get_room_slug(changeset)
    url = [
      URI.to_string(socket.host_uri),
      "dreadnought/play",
      room_slug
    ]
    |> Enum.join("/")
    |> IOP.inspect("join room url")
    assign(socket, maybe_url: url, changeset: changeset)
  end

  defp maybe_redirect_away_from_room(socket) do
    IOP.inspect socket.assigns, "join comp maybe redirect"
    if !socket.assigns.changeset.valid? do
      # TODO extract route to function
      send self(), {:push_patch, to: "/dreadnought/play"}
    end
    socket
  end

end
