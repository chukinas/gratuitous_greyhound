defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.{Game, ViewModel}

  @impl true
  def mount(_params, _session, socket) do
    game = Game.init({1, "a"})
    socket =
      socket
      |> assign(:game, game)
      |> assign(:vm, ViewModel.build(game))
    {:ok, socket}
  end

  # @impl true
  # def handle_event("select_space", %{"x" => x, "y" => y}, socket) do
  #   IO.puts("selected a space: {#{x}, #{y}}")
  #   {:noreply, socket}
  # end
end
