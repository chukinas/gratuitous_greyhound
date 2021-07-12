defmodule ChukinasWeb.RoomJoinComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Phoenix.HTML
  alias Chukinas.Sessions
  alias Ecto.Changeset

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(player_uuid: assigns.uuid)
      |> assign_changeset_and_url(%{}, false)
    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"room_join" => params}, socket) do
    socket = assign_changeset_and_url(socket, params)
    {:noreply, socket}
  end

  def handle_event("join", %{"room_join" => params}, socket) do
    attrs = params_to_attrs(params, socket)
    socket =
      case Sessions.room_join_validate(attrs) do
        {:ok, room_join} ->
          :ok = Sessions.join_room(room_join)
          socket
        {:error, _changeset} ->
          assign_changeset_and_url(socket, params)
      end
    {:noreply, socket}
  end

  # *** *******************************
  # *** PRIVATE

  defp assign_changeset_and_url(socket, changeset_or_params, show_errors? \\ true)

  defp assign_changeset_and_url(socket, %Changeset{} = changeset, show_errors?) do
    changeset = if show_errors? do
      # TODO I shouldn't be manipulating the raw map..?
      Map.put(changeset, :action, :insert)
    else
      changeset
    end
    socket
    |> assign(changeset: changeset)
    |> assign_url
  end

  defp assign_changeset_and_url(socket, params, show_errors?) do
    attrs = params_to_attrs(params, socket)
    changeset =
      changeset_data()
      |> Sessions.room_join_changeset(attrs)
    # TODO is this necessary?
      |> Changeset.cast(attrs, [:room_name_raw])
    assign_changeset_and_url(socket, changeset, show_errors?)
  end

  defp params_to_attrs(params, socket) do
    params
    |> Map.put("room_name", params["room_name_raw"])
    |> Map.put("player_uuid", socket.assigns.player_uuid)
  end

  defp assign_url(socket) do
    assign(socket, maybe_url: build_url(socket))
  end

  defp build_url(socket) do
    Enum.join [
      URI.to_string(socket.host_uri),
      build_path(socket),
    ]
  end

  defp build_path(socket) do
    Enum.join [
      Routes.dreadnought_path(socket, :setup),
      Changeset.get_field(socket.assigns.changeset, :room_name)
    ], "/"
  end

  defp changeset_data do
    types =
      Sessions.room_join_types()
      |> Map.put(:room_name_raw, :string)
    {%{}, types}
  end

end
