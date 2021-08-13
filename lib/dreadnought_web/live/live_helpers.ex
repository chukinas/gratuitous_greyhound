defmodule DreadnoughtWeb.LiveHelpers do
  @moduledoc"""
  Provides common functions to DreadnoughtLive and DreadnoughtPlayLive
  """

  alias DreadnoughtWeb.Router.Helpers, as: Routes
  alias Dreadnought.Missions
  alias Dreadnought.Players

  @live_action_mapping %{
    menus: :setup,
    play: :play
  }

  @opts Map.keys @live_action_mapping

  defmacro __using__(opts) when opts in @opts do
    quote do

      use DreadnoughtWeb, :live_view
      alias Dreadnought.Core.Mission

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
        socket
        |> push_redirect(to: Routes.dreadnought_main_path(socket, :homepage))
        |> noreply
      end

      @impl true
      def handle_info({:update_mission, %Mission{} = mission}, socket) do
        if mission_in_progress?(mission) && socket.assigns.live_action != :play do
          socket
          |> push_redirect(to: Routes.dreadnought_main_path(socket, :play))
          |> noreply
        else
          socket
          |> assign(mission: mission)
          |> noreply
        end
      end

      # *** *******************************
      # *** SOCKET REDUCERS

      def assign_page_title(socket), do: assign(socket, page_title: "Dreadnought")

      @spec assign_uuid_and_mission(Phoenix.LiveView.Socket.t, map) :: Phoenix.LiveView.Socket.t
      def assign_uuid_and_mission(socket, %{"uuid" => uuid} = _session) do
        if socket.connected? do
          Players.register_liveview(uuid)
          socket
          |> assign(uuid: uuid)
          |> assign(mission: Missions.get_mission_from_player_uuid(uuid))
        else
          socket
          |> assign(uuid: uuid)
          |> assign(mission: nil)
        end
      end

      def maybe_redirect_to_setup(socket) do
        if not mission_in_progress?(socket) do
          path = Routes.dreadnought_main_path(socket, :setup)
          send self(), {:push_redirect, path}
        end
        socket
      end

      # *** *******************************
      # *** SOCKET CONVERTERS

      def mission_in_progress?(socket) do
        with %Dreadnought.Core.Mission{} = mission <- mission(socket),
             true <- Dreadnought.Core.Mission.in_progress?(mission) do
          true
        else
          _ -> false
        end
      end

      # *** *******************************
      # *** HELPERS

      # TODO this is ugly
      def mission(nil), do: nil
      def mission(%Dreadnought.Core.Mission{} = value), do: value
      def mission(socket), do: socket.assigns[:mission]

    end
  end

end
