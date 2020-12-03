defmodule Chukinas.Skies.Game do

  alias Chukinas.Skies.Game.{
    Bomber,
    Box,
    Boxes,
    Bombers,
    Fighter,
    Spaces,
    Squadron,
    TacticalPoints,
    Turn,
    Phase,
  }

  defstruct [
    :spaces,
    :bombers,
    :squadron,
    :turn,
    :phase,
    :tactical_points,
    :boxes,
  ]

  @type t :: %__MODULE__{
    spaces: any(),
    bombers: any(),
    squadron: any(),
    turn: Turn.t(),
    phase: Phase.t(),
    tactical_points: TacticalPoints.t(),
    boxes: Boxes.t(),
  }

  @type token :: {atom(), t()}

  # *** *******************************
  # *** NEW

  @spec new(any()) :: t()
  def new(map_id) do
    %__MODULE__{
      spaces: Spaces.new(map_id),
      bombers: Bombers.new(map_id),
      squadron: Squadron.new(),
      turn: Turn.new(),
      phase: Phase.new(),
      tactical_points: TacticalPoints.new(),
      boxes: Boxes.new(),
    }
  end

  # *** *******************************
  # *** API

  def select_group(%__MODULE__{squadron: s} = game, group_id) do
    squadron = s |> Squadron.select_group(group_id)
    %{game | squadron: squadron}
  end

  def toggle_fighter_select(%__MODULE__{squadron: s} = game, fighter_id) do
    %{game | squadron: Squadron.toggle_fighter_select(s, fighter_id)}
  end

  def do_not_move(%__MODULE__{
    squadron: s,
    tactical_points: tp
  } = game) do
    s = Squadron.do_not_move(s)
    tp = TacticalPoints.update_spent_this_phase(tp, s, game.boxes)
    %{game | squadron: s, tactical_points: tp}
  end

  def move(%__MODULE__{} = game, location) do
    s = Squadron.move(game.squadron, Box.id_from_string(location))
    tp = TacticalPoints.update_spent_this_phase(game.tactical_points, s, game.boxes)
    %{game | squadron: s, tactical_points: tp}
  end

  def attack(%__MODULE__{} = game, bomber_id) do
    s = Squadron.attack(game.squadron, Bomber.id_from_client_id(bomber_id))
    %{game | squadron: s}
  end

  @spec end_phase(t()) :: t()
  def end_phase(%__MODULE__{} = game) do
    {_, game} = {:cont, game}
    |> maybe_next_phase()
    |> maybe_next_turn()
    |> maybe_end_game()
    |> maybe_skip_phase()
    game
  end

  # *** *******************************
  # *** HELPERS

  defp maybe_next_phase({:cont, game}) do
    cond do
      not Squadron.done?(game.squadron) ->
        {:stop, game}
      Squadron.all_fighters?(game.squadron, &Fighter.delayed_entry?/1) ->
        game
        |> Map.update!(:phase, &Phase.next/1)
        |> build_token(:all_delayed_entry)
      true ->
        phase = Phase.next(game.phase)
        game
        |> Map.put(:phase, phase)
        |> Map.update!(:tactical_points, &TacticalPoints.commit_spent_point/1)
        |> Map.update!(:squadron, &Squadron.start_phase(&1, phase.name))
        |> build_token(:cont)
    end
  end

  defp maybe_next_turn({:stop, _} = token), do: token
  defp maybe_next_turn({:all_delayed_entry, game}) do
    game
    |> Map.update!(:turn, &Turn.next/1)
    |> build_token(:stop)
  end
  defp maybe_next_turn({:cont, game}) do
    if game.phase.is?.(:move) do
      game
      |> Map.update!(:turn, &Turn.next/1)
      |> Map.update!(:squadron, &Squadron.next_turn/1)
      |> build_token(:cont)
    else
      {:cont, game}
    end
  end

  @spec maybe_end_game(token()) :: token()
  defp maybe_end_game({:stop, _} = token), do: token
  defp maybe_end_game({:cont, game}) do
    cond do
      game.turn.end_game? ->
        # FIX implement
        {:stop, game}
      true ->
        {:cont, game}
    end
  end

  @spec maybe_skip_phase(token()) :: token()
  defp maybe_skip_phase({:stop, _} = token), do: token
  defp maybe_skip_phase({:cont, game}) do
    if play_phase?(game) do
      {:cont, game}
    else
      {:cont, end_phase(game)}
    end
  end

  @spec build_token(t(), atom()) :: token()
  defp build_token(game, response), do: {response, game}

  @spec play_phase?(t()) :: boolean()
  defp play_phase?(%__MODULE__{phase: %{name: :move}} = game) do
    Enum.any?(game.squadron.fighters, &Fighter.available_this_turn?/1)
  end
  defp play_phase?(%__MODULE__{phase: %{name: :approach}} = game) do
    Enum.any?(game.squadron.fighters, fn f ->
      Box.approach?(f.box_move)
    end)
  end
  defp play_phase?(_), do: false

end
