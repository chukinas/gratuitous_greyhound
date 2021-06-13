alias Chukinas.Sessions
alias Chukinas.Sessions.{User, UserSession}

defmodule ChukinasWeb.JoinComponent do
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def update(assigns, socket) do
    user_session = assigns[:user_session]
    changeset =
      Sessions.user_session_changeset(
        user_session,
        user_session_attrs(%{})
      )
    socket =
      socket
      |> assign(user_session: user_session)
      |> assign(user: assigns.user)
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
      with {:ok, user_session} <- Sessions.update_user_session(socket.assigns.user_session, params),
           user                <- User.merge_user_session(socket.assigns.user, user_session),
           room_name           <- UserSession.room(user_session),
           {:ok, _user}        <- Sessions.join_room(user, room_name) do
        socket
      else
        {:error, changeset} -> assign_changeset_and_url(socket, changeset)
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
    ]
  end

  def build_url(socket, user_session) do
    Enum.join [
      URI.to_string(socket.host_uri),
      Routes.dreadnought_path(socket, :join),
      Sessions.room_name(user_session),
    ]
  end

end
