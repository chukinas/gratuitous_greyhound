alias Chukinas.Dreadnought.{MissionBuilder}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

  @impl true
  def mount(_params, _session, socket) do
    mission =
      MissionBuilder.from_live_action(socket.assigns.live_action)
    socket =
      socket
      |> assign(page_title: "Dreadnought")
      |> assign(mission: mission)
      |> assign(player_id: 1)
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, url, socket) do
    socket = case socket.assigns.live_action do
      :play -> assign(socket, :mission, MissionBuilder.grid_lab)
      _ -> socket
    end
    if String.ends_with?(url, "dreadnought/") or String.ends_with?(url, "dreadnought") do
      {:noreply, push_patch(socket, to: "/dreadnought/welcome")}
    else
      {:noreply, socket}
    end
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
      MissionBuilder.from_live_action(socket.assigns.live_action)
    send_update Dreadnought.DynamicWorldComponent, id: :dynamic_world, mission: mission
    {:noreply, socket}
  end

  def issue_link(title, number) do
    assigns = %{title: title, number: number, __changed__: nil}
    ~L"""
    <%= @title %> - <a class="underline" href="https://github.com/jonathanchukinas/chukinas/issues/<%= @number %>" target="_blank">issue/<%= @number %></a>
    """
  end

  # TODO delete
  @impl true
  def handle_info({:flash, message}, socket) do
    {:noreply, put_flash(socket, :info, message)}
  end

  # TODO delete
  @impl true
  def handle_info(:reset_mission, socket) do
    mission =
      MissionBuilder.from_live_action(socket.assigns.live_action)
    send_update Dreadnought.DynamicWorldComponent, id: :dynamic_world, mission: mission
    {:noreply, socket}
  end

  def template(template, assigns), do: DreadnoughtView.render template, assigns
end
