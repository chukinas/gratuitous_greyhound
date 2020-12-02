defmodule ChukinasWeb.SkiesLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Skies.{Game, ViewModel}
  import ChukinasWeb.SkiesView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Skies Above the Reich")
    {_, socket} = Game.new({1, "a"})
    |> assign_game_and_vm(socket)
    {:ok, socket}
  end

  @impl true
  def handle_event("end_phase", _, socket) do
    socket.assigns.game
    |> Game.end_phase()
    |> assign_game_and_vm(socket)
  end

  @impl true
  def handle_event("select_group", %{"group_id" => id}, socket) do
    socket.assigns.game
    |> Game.select_group(String.to_integer(id))
    |> assign_game_and_vm(socket)
  end

  @impl true
  def handle_event("toggle_fighter_select", %{"id" => id}, socket) do
    socket.assigns.game
    |> Game.toggle_fighter_select(String.to_integer(id))
    |> assign_game_and_vm(socket)
  end

  @impl true
  def handle_event("do_not_move", _, socket) do
    socket.assigns.game
    |> Game.do_not_move()
    |> assign_game_and_vm(socket)
  end

  @impl true
  # Move the pattern matching to game func?
  def handle_event("move", %{"id" => box_id}, socket) do
    socket.assigns.game
    |> Game.move(box_id)
    |> assign_game_and_vm(socket)
  end

  @impl true
  # Move the pattern matching to game func?
  def handle_event("attack", %{"id" => bomber_id}, socket) do
    socket.assigns.game
    |> Game.attack(bomber_id)
    |> assign_game_and_vm(socket)
  end

  defp assign_game_and_vm(game, socket) do
    socket = socket
    |> assign(:game, game)
    |> assign(:vm, ViewModel.build(game))
    {:noreply, socket}
  end

  # TODO centralize phase done and skip checks
  # TODO handle unselect

end
