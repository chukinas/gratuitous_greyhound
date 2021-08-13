defmodule DreadnoughtWeb.NewPlayerComponent do

  use DreadnoughtWeb, :live_component
  alias Dreadnought.Multiplayer
  alias Dreadnought.Multiplayer.NewPlayer

  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def update(%{uuid: uuid} = _assigns, socket) do
    {:ok,
      socket
      |> assign(uuid: uuid)
      |> assign_new_player
      |> assign_changeset
    }
  end

  @impl true
  def handle_event(
      "validate",
      %{"new_player" => new_player_params},
      %{assigns: %{new_player: new_player}} = socket) do
    changeset =
      new_player
      |> Multiplayer.change_new_player(new_player_params)
      |> Map.put(:action, :validate)
    {:noreply,
      socket
      |> assign(changeset: changeset)}
  end

  def handle_event(
      "add_player",
      %{"new_player" => new_player_params},
      %{assigns: %{new_player: new_player}} = socket) do
    case Multiplayer.add_player(new_player, new_player_params) do
      {:ok, _new_player} ->
        {:noreply,
          socket
          #|> put_flash(:info, "Joined Mission!")
          |> assign_changeset}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
          socket
          #|> put_flash(:info, "Failed to add player")
          |> assign(changeset: changeset)}
    end
  end

  # *** *******************************
  # *** PRIVATE

  def assign_new_player(%{assigns: %{uuid: uuid}} = socket) do
    socket
    |> assign(new_player: %NewPlayer{uuid: uuid})
  end

  def assign_changeset(%{assigns: %{new_player: new_player}} = socket) do
    socket
    |> assign(changeset: Multiplayer.change_new_player(new_player))
  end

  #defp assign_changeset_and_url(socket, params, show_errors?) do
  #  attrs = params_to_attrs(params, socket)
  #  changeset =
  #    changeset_data()
  #    |> Sessions.room_join_changeset(attrs)
  #  # TODO is this necessary?
  #    |> Changeset.cast(attrs, [:room_name_raw])
  #  assign_changeset_and_url(socket, changeset, show_errors?)
  #end

  #defp params_to_attrs(params, socket) do
  #  params
  #  |> Map.put("room_name", params["room_name_raw"])
  #  |> Map.put("player_uuid", socket.assigns.player_uuid)
  #end

  #defp assign_url(socket) do
  #  assign(socket, maybe_url: build_url(socket))
  #end

  #defp build_url(socket) do
  #  Enum.join [
  #    URI.to_string(socket.host_uri),
  #    build_path(socket),
  #  ]
  #end

  #defp build_path(socket) do
  #  Enum.join [
  #    Routes.dreadnought_main_path(socket, :setup),
  #    Changeset.get_field(socket.assigns.changeset, :room_name)
  #  ], "/"
  #end

  #defp changeset_data do
  #  types =
  #    Sessions.room_join_types()
  #    |> Map.put(:room_name_raw, :string)
  #  {%{}, types}
  #end

end
