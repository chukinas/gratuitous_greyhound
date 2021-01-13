defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Model.Deck

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(deck: Deck.new(1))
    |> assign(angles: ~w"000 030 045 060 090 180")
    {:ok, socket}
  end

end
