defmodule ChukinasWeb.DreadnoughtLiveViewHelpers do
  @moduledoc"""
  Provides common functions to DreadnoughtLive and DreadnoughtPlayLive
  """

  alias ChukinasWeb.Router.Helpers, as: Routes
  alias Chukinas.Sessions

  @live_action_mapping %{
    menus: :setup,
    play: :play
  }

  @opts Map.keys @live_action_mapping


  defmacro __using__(opts) when opts in @opts do

    quote do

      use ChukinasWeb, :live_view
      alias Chukinas.Dreadnought.Mission

      # *** *******************************
      # *** CALLBACKS

      @impl true
      def handle_info({:push_redirect, path}, socket) do
        socket
        |> push_redirect(to: path)
        |> noreply
      end

      @impl true
      def handle_info({:update_mission, nil}, socket) do
        if socket.assigns.live_action == :play do
          socket
          |> push_redirect(to: Routes.dreadnought_main_path(socket, :setup))
          |> noreply
        else
          socket
          |> assign(mission: nil)
          |> noreply
        end
      end

      @impl true
      def handle_info({:update_mission, %Mission{} = mission}, socket) do
        cond do
          mission_in_progress?(mission) ->
            path = Routes.dreadnought_main_path(socket, :play)
            socket
            |> push_redirect(to: path)
            |> noreply
          true ->
            socket
            |> assign(mission: mission)
            |> noreply
        end
      end

      # *** *******************************
      # *** HELPERS

      @spec assign_uuid_and_mission(Phoenix.LiveView.Socket.t, map) :: Phoenix.LiveView.Socket.t
      def assign_uuid_and_mission(socket, session) do
        uuid = Map.fetch!(session, "uuid")
        if socket.connected? do
          Sessions.register_uuid(uuid)
          socket
          |> assign(uuid: uuid)
          |> assign(mission: Sessions.get_mission_from_player_uuid(uuid))
        else
          socket
          |> assign(uuid: uuid)
          |> assign(mission: nil)
        end
      end

      def mission_in_progress?(socket) do
        with %Chukinas.Dreadnought.Mission{} = mission <- mission(socket),
             true <- Chukinas.Dreadnought.Mission.in_progress?(mission) do
          true
        else
          _ -> false
        end
      end

      # TODO this is ugly
      def mission(nil), do: nil
      def mission(%Chukinas.Dreadnought.Mission{} = value), do: value
      def mission(socket), do: socket.assigns[:mission]

      def maybe_redirect_to_setup(socket) do
        if not mission_in_progress?(socket) do
          path = Routes.dreadnought_main_path(socket, :setup)
          send self(), {:push_redirect, path}
        end
        socket
      end

      def assign_page_title(socket), do: assign(socket, page_title: "Dreadnought")

    end
  end

end
