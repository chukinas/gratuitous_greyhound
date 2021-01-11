defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(angles: ~w"000 030 045 060 090 ")
    {:ok, socket}
  end

end
