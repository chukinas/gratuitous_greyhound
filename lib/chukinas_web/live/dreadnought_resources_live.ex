alias Chukinas.Dreadnought.{Mission, MissionBuilder, State}

defmodule ChukinasWeb.DreadnoughtResourcesLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

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
end
