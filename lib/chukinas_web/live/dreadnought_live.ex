alias Chukinas.Dreadnought.{Mission, MissionBuilder}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

  @impl true
  def mount(_params, _session, socket) do
    mission = MissionBuilder.build()
    socket = assign(socket,
      page_title: "Dreadnought",
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
  def handle_event("log", params, socket) do
    IOP.inspect params
    {:noreply, socket}
  end

  @impl true
  def handle_event("route_to", %{"route" => route}, socket) do
    {:noreply, push_patch(socket, to: route)}
  end

  @impl true
  def handle_event("game_over", _, socket) do
    socket =
      socket
      |> put_flash(:info, "You have no available moves! Play again.")
    mission =
      MissionBuilder.build()
    send_update Dreadnought.DynamicWorldComponent, id: :dynamic_world, mission: mission
    {:noreply, socket}
  end

  def issue_link(title, number) do
    assigns = %{title: title, number: number, __changed__: nil}
    ~L"""
    <%= @title %> - <a class="underline" href="https://github.com/jonathanchukinas/chukinas/issues/<%= @number %>" target="_blank">issue/<%= @number %></a>
    """
  end

  @impl true
  # TODO rename mission_player to `player_turn` PlayerTurn
  def handle_info({:player_turn_complete, mission_player}, socket) do
    mission =
      socket.assigns.mission
      |> Mission.complete_player_turn(mission_player)
    mission_player =
      mission
      |> Mission.to_player
    # TODO use alias to shorten this call..
    send_update Dreadnought.DynamicWorldComponent, id: :dynamic_world, mission_player: mission_player
    {:noreply, socket}
  end

  def template(template, assigns), do: DreadnoughtView.render template, assigns
end
