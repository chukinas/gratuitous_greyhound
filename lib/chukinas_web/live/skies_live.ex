defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.{Game, ViewModel}
  # alias Chukinas.Skies.Game.{TurnManager}
  import ChukinasWeb.SkiesView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Skies Above the Reich")
    |> assign_game_and_vm(Game.init({1, "a"}))

    {:ok, socket}
  end

  # @impl true
  # def handle_event("select_space", %{"x" => x, "y" => y}, socket) do
  #   IO.puts("selected a space: {#{x}, #{y}}")
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event("next_phase", _, socket) do
    game = socket.assigns.game
    |> Map.update!(:turn_manager, &Game.TurnManager.advance_to_next_phase/1)
    socket = assign_game_and_vm(socket, game)
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_group", stuff, socket) do
    IO.inspect(stuff)
    # game = socket.assigns.game
    # |> Map.update!(:turn_manager, &Game.TurnManager.advance_to_next_phase/1)
    # socket = assign_game_and_vm(socket, game)
    {:noreply, socket}
  end

  @spec assign_game_and_vm(any(), any()) :: any()
  defp assign_game_and_vm(socket, game) do
    socket
    |> assign(:game, game)
    |> assign(:vm, ViewModel.render(game))
  end


end
