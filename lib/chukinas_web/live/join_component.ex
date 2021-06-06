alias Chukinas.Sessions
alias Chukinas.Sessions.UserSession

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
        user_session_attrs(assigns.path_params)
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
    case Sessions.update_user_session(socket.assigns.user_session, params) do
      # TODO use `with`?
      {:ok, user_session} ->
        {:ok, user} = Sessions.join_room(socket.assigns.user, user_session |> UserSession.room)
        send self(), {:update_assigns, %{user_session: user_session, show_join_screen?: false, user: user}}
        socket =
          socket
          |> push_patch(to: Sessions.path(socket, Sessions.room(user_session)))
        {:noreply, socket}
      {:error, changeset} ->
        socket =
          socket
          |> assign_changeset_and_url(changeset)
        {:noreply, socket}
    end
  end

  def assign_changeset_and_url(socket, changeset, show_errors? \\ true) do
    # TODO I shouldn't be manipulating the raw map..?
    changeset = if show_errors?, do: Map.put(changeset, :action, :insert), else: changeset
    url = Sessions.url(socket, changeset)
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

end
