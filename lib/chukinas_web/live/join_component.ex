alias Chukinas.Sessions

defmodule ChukinasWeb.JoinComponent do
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def update(assigns, socket) do
    user_sessions_attrs =
      case assigns.user_session do
        nil -> %{}
        user_session -> user_session
      end
      |> Map.merge(assigns.path_params)
      |> IOP.inspect("join comp update, attrs")
    {:error, changeset} = Sessions.create_user_session()
    changeset = Enum.reduce(user_sessions_attrs, changeset, fn {key, value}, changeset ->
      key =
        cond do
          is_atom(key) -> key
          true -> String.to_atom(key)
        end
      Ecto.Changeset.put_change(changeset, key, value)
    end)
    socket =
      socket
      |> assign_changeset_and_url(changeset, false)
    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    # TODO this shouldn't return a tuple
    # TODO rename user_session_changeset
    changeset = Sessions.changeset_user_session(params)
    socket = assign_changeset_and_url(socket, changeset)
    {:noreply, socket}
  end

  # TODO rename "join"
  def handle_event("save", %{"user_session" => params}, socket) do
    case Sessions.create_user_session(params) do
      {:error, changeset} ->
        socket =
          socket
          |> assign_changeset_and_url(changeset)
        {:noreply, socket}
      {:ok, user_session} ->
        send self(), {:update_assigns, %{user_session: user_session, show_join_screen?: false}}
        socket =
          socket
          |> push_patch(to: path(socket, user_session))
        {:noreply, socket}
    end
  end

  def assign_changeset_and_url(socket, changeset, show_errors? \\ true) do
    changeset = if show_errors?, do: Map.put(changeset, :action, :insert), else: changeset
    url = url(socket, changeset)
    assign(socket, maybe_url: url, changeset: changeset)
  end

  defp path(socket, user_session) do
    room = Sessions.get_room(user_session)
    Routes.dreadnought_path(socket, :room, room)
  end

  defp url(socket, user_session) do
    [
      URI.to_string(socket.host_uri),
      path(socket, user_session)
    ]
    |> Enum.join
  end

end
