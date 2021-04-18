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
      sprites: sprites
    )
    {:ok, socket}
  end
end
