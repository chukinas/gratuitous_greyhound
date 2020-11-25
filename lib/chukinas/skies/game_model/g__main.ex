defmodule Chukinas.Skies.Game do

  alias Chukinas.Skies.Game.{
    Box,
    Boxes,
    Elements,
    Fighter,
    Positions,
    Spaces,
    Squadron,
    TacticalPoints,
    TurnManager,
  }

  defstruct [
    :spaces,
    :elements,
    :squadron,
    :turn_manager,
    :tactical_points,
    :boxes,
  ]

  @type t :: %__MODULE__{
    spaces: any(),
    elements: any(),
    squadron: any(),
    turn_manager: TurnManager.t(),
    tactical_points: TacticalPoints.t(),
    boxes: Positions.t(),
  }

  @spec new(any()) :: t()
  def new(map_id) do
    %__MODULE__{
      spaces: Spaces.new(map_id),
      elements: Elements.new(map_id),
      squadron: Squadron.new(),
      turn_manager: TurnManager.new(),
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

  def move(%__MODULE__{} = game, location) when is_binary(location) do
    s = Squadron.move(game.squadron, Box.id_from_string(location))
    tp = TacticalPoints.update_spent_this_phase(game.tactical_points, s, game.boxes)
    %{game | squadron: s, tactical_points: tp}
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
        |> Map.update!(:turn_manager, &TurnManager.next_phase/1)
        |> build_token(:all_delayed_entry)
      true ->
        game
        |> Map.update!(:turn_manager, &TurnManager.next_phase/1)
        |> Map.update!(:tactical_points, &TacticalPoints.commit_spent_point/1)
        |> build_token(:cont)
    end
  end

  defp maybe_next_turn({:stop, _} = token), do: token
  defp maybe_next_turn({:all_delayed_entry, game}) do
    game
    |> Map.update!(:turn_manager, &TurnManager.next_turn/1)
    |> build_token(:stop)
  end
  defp maybe_next_turn({:cont, game}) do
    # TODO abstract this out:
    if TurnManager.current_phase?(game.turn_manager, :move) do
      game
      # TODO make sure this forces the phase to Move
      |> Map.update!(:turn_manager, &TurnManager.next_turn/1)
      # TODO unify language
      |> Map.update!(:squadron, &Squadron.start_new_turn/1)
      |> build_token(:cont)
    else
      {:cont, game}
    end
  end

  defp maybe_end_game({:stop, _} = token), do: token
  defp maybe_end_game({:cont, game}) do
    cond do
      TurnManager.end_game?(game.turn_manager) ->
        # FIX implement
        {:stop, game}
      true ->
        {:cont, game}
    end
  end

  defp maybe_skip_phase({:stop, _} = token), do: token
  defp maybe_skip_phase({:cont, game}) do
    cond do
      move?(game) -> {:cont, game}
      attack?(game) -> {:cont, game}
      true -> {:cont, end_phase(game)}
    end
  end

  defp build_token(game, response), do: {response, game}

  defp move?(game) do
    TurnManager.current_phase?(game.turn_manager, :move) &&
      Enum.any?(game.squadron.fighters, &Fighter.available_this_turn?/1)
  end

  defp attack?(game) do
    TurnManager.current_phase?(game.turn_manager, :approach) &&
      Enum.any?(game.squadron.fighters, fn f ->
        Box.approach?(f.box_end)
      end)
  end

end
