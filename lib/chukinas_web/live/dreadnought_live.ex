defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    {:ok, socket}
  end

end
