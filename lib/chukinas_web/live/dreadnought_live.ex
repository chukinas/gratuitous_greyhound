alias Chukinas.Dreadnought.{Mission, MissionBuilder, State}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.Dreadnought

  @impl true
  def render(assigns) do
    ChukinasWeb.DreadnoughtView.render "layout_gameplay.html", assigns
  end

  @impl true
  def mount(_params, _session, socket) do
    {pid, mission} = State.start_link()
    socket = assign(socket,
      page_title: "Dreadnought",
      pid: pid,
      mission: mission,
      mission_playing_surface: Mission.to_playing_surface(mission) |> Map.from_struct,
      mission_player: Mission.to_player(mission)
    )
    {:ok, socket}
  end

  #@impl true
  #def handle_params(_params, url, socket) do
  #  socket = case socket.assigns.live_action do
  #    :play -> assign(socket, :mission, MissionBuilder.demo |> Mission.build_view)
  #    _ -> socket
  #  end
  #  #if String.ends_with?(url, "dreadnought/") or String.ends_with?(url, "dreadnought") do
  #  #  {:noreply, push_patch(socket, to: "/dreadnought/welcome")}
  #  #else
  #  {:noreply, socket}
  #  #end
  #end

  @impl true
  def handle_params(_params, url, socket) do
    socket = case socket.assigns.live_action do
      :play -> assign(socket, :mission, MissionBuilder.build())
      _ -> socket
    end
    if String.ends_with?(url, "dreadnought/") or String.ends_with?(url, "dreadnought") do
      {:noreply, push_patch(socket, to: "/dreadnought/welcome")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("log", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("route_to", %{"route" => route}, socket) do
    {:noreply, push_patch(socket, to: route)}
  end

  #@impl true
  #def handle_event("game_over", _, socket) do
  #  socket =
  #    socket
  #    |> put_flash(:info, "You have no available moves! Play again.")
  #  mission =
  #    MissionBuilder.build()
  #  send_update Dreadnought.DynamicWorldComponent, id: :dynamic_world, mission: mission
  #  {:noreply, socket}
  #end

  @impl true
  # TODO rename mission_player to `player_turn` PlayerTurn
  def handle_info({:player_turn_complete, player_actions}, socket) do
    #mission =
    #  socket.assigns.mission
    #  |> Mission.put(units)
    #  |> Mission.complete_player_turn(commands)
    #mission_player =
    #  mission
    #  |> Mission.to_player
    #socket =
    #  socket
    #  |> assign(mission: mission)
    # TODO use alias to shorten this call..
    mission_player = State.complete_player_turn(socket.assigns.pid, player_actions)
    send_update Dreadnought.DynamicWorldComponent, mission_player
    {:noreply, socket}
  end
end
