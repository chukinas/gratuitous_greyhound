defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.{Game, ViewModel}
  import ChukinasWeb.SkiesView

  @impl true
  def mount(_params, _session, socket) do
    {_, socket} = socket
    |> assign(page_title: "Skies Above the Reich")
    |> assign_game_and_vm(Game.new({1, "a"}))
    {:ok, socket}
  end

  # @impl true
  # def handle_event("select_space", %{"x" => x, "y" => y}, socket) do
  #   IO.puts("selected a space: {#{x}, #{y}}")
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event("end_phase", _, socket) do
    game = Game.end_phase(socket.assigns.game)
    assign_game_and_vm(socket, game)
  end

  @impl true
  def handle_event("select_group", %{"group_id" => id}, socket) do
    game = Game.select_group(
      socket.assigns.game,
      String.to_integer(id)
    )
    assign_game_and_vm(socket, game)
  end

  @impl true
  def handle_event("toggle_fighter_select", %{"id" => id}, socket) do
    game = Game.toggle_fighter_select(
      socket.assigns.game,
      String.to_integer(id)
    )
    assign_game_and_vm(socket, game)
  end

  @impl true
  def handle_event("delay_entry", _, socket) do
    game = socket.assigns.game |> Game.delay_entry()
    assign_game_and_vm(socket, game)
  end

  @impl true
  # TODO where used?
  def handle_event("commit_order", _params, socket) do
    {:noreply, socket}
  end

  @spec assign_game_and_vm(any(), any()) :: any()
  defp assign_game_and_vm(socket, game) do
    socket = socket
    |> assign(:game, game)
    |> assign(:vm, ViewModel.build(game))
    {:noreply, socket}
  end


end
