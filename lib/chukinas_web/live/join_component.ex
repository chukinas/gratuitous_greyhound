defmodule ChukinasWeb.JoinComponent do

  alias Chukinas.Sessions
  alias Chukinas.Sessions.UserSession
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def update(assigns, socket) do
    user_session = nil
    changeset =
      Sessions.user_session_changeset(
        user_session,
        user_session_attrs(%{})
      )
    socket =
      socket
      |> assign(user_session: user_session)
      |> assign(uuid: assigns.uuid)
      |> assign_changeset_and_url(changeset, false)
    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    changeset =
      Sessions.user_session_changeset(
        socket.assigns.user_session,
        # TODO do I need to include the path_params again?
        # or do they persist as raw input now?
        params
      )
    socket = assign_changeset_and_url(socket, changeset)
    {:noreply, socket}
  end

  def handle_event("join", %{"user_session" => params}, socket) do
    socket =
      case Sessions.join_room(socket.assigns.user_session, params) do
        {:ok, user_session} ->
          room_name = UserSession.room(user_session)
          player_uuid = socket.assigns.uuid
          player_name = UserSession.username(user_session)
          :ok = Sessions.do_join_room(room_name, player_uuid, player_name)
          socket
        {:error, changeset} ->
          assign_changeset_and_url(socket, changeset)
      end
    {:noreply, socket}
  end

  def assign_changeset_and_url(socket, changeset, show_errors? \\ true) do
    # TODO I shouldn't be manipulating the raw map..?
    changeset = if show_errors?, do: Map.put(changeset, :action, :insert), else: changeset
    url = build_url(socket, changeset)
    assign(socket, maybe_url: url, changeset: changeset)
  end

  # *** *******************************
  # *** FUNCTIONS

  def user_session_attrs(assigns) do
    user_session_attrs(assigns, %{})
  end

  def user_session_attrs(%{"username" => username} = assigns, attrs) do
    assigns = Map.drop(assigns, ["username"])
    attrs = Map.put(attrs, :username, username)
    user_session_attrs(assigns, attrs)
  end

  def user_session_attrs(%{"room" => room_raw} = assigns, attrs) do
    assigns = Map.drop(assigns, ["room"])
    attrs = Map.put(attrs, :room_raw, room_raw)
    user_session_attrs(assigns, attrs)
  end

  def user_session_attrs(_assigns, attrs), do: attrs

  def build_path(socket, user_session) do
    Enum.join [
      Routes.dreadnought_path(socket, :join),
      Sessions.room_name(user_session),
    ], "/"
  end

  def build_url(socket, user_session) do
    Enum.join [
      URI.to_string(socket.host_uri),
      build_path(socket, user_session),
    ]
  end

end
