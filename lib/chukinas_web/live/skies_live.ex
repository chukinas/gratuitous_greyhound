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

  # @impl true
  # def handle_event("select_space", %{"x" => x, "y" => y}, socket) do
  #   IO.puts("selected a space: {#{x}, #{y}}")
  #   {:noreply, socket}
  # end

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
  def handle_event("delay_entry", _, socket) do
    socket.assigns.game
    |> Game.delay_entry()
    |> assign_game_and_vm(socket)
  end

  @impl true
  # Move the pattern matching to game func?
  def handle_event("select_box", %{"id" => id}, socket) do
    socket.assigns.game
    |> Game.select_box(id)
    |> assign_game_and_vm(socket)
  end

  defp assign_game_and_vm(game, socket) do
    socket = socket
    |> assign(:game, game)
    |> assign(:vm, ViewModel.build(game))
    {:noreply, socket}
  end


end
