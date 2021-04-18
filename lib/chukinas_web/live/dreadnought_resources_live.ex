alias Chukinas.Dreadnought.{Spritesheet}

defmodule ChukinasWeb.DreadnoughtResourcesLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

  @impl true
  def mount(_params, _session, socket) do
    sprites =
      ~w(ship_large ship_small turret1 turret2 shell1 shell2 muzzle_flash)
      |> Enum.map(&Spritesheet.red/1)
    socket = assign(socket,
      page_title: "Dreadnought Resources",
      show_markers?: true,
      sprites: sprites
    )
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
    {:noreply, socket}
  end
end
