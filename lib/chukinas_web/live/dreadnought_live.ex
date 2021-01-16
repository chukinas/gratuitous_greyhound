defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Deck
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(deck: Deck.new(1) |> Deck.draw(5))
    {:ok, socket}
  end

end
