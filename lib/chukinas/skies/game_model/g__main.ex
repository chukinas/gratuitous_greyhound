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
    tp = TacticalPoints.calculate(tp, s, game.boxes)
    %{game | squadron: s, tactical_points: tp}
  end

  def move(%__MODULE__{} = game, location) when is_binary(location) do
    s = Squadron.move(game.squadron, Box.id_from_string(location))
    tp = TacticalPoints.calculate(game.tactical_points, s, game.boxes)
    %{game | squadron: s, tactical_points: tp}
  end

  @spec end_phase(t()) :: t()
  def end_phase(%__MODULE__{squadron: s} = game) do
    cond do
      # TODO use 'not'?
      !Squadron.done?(s) -> game
      true ->
        game
        # TODO extract this out into a private next_turn
        |> Map.update!(:turn_manager, &TurnManager.next_turn/1)
        |> Map.update!(:tactical_points, &TacticalPoints.commit_spent_point/1)
        |> Map.update!(:squadron, &Squadron.start_new_turn/1)
      # not TurnManager.current_phase?(tm, :move) ->
      #   Map.update!(game, :turn_manager, &TurnManager.next_phase/1)
      # Squadron.all_fighters?(s, &Fighter.delayed_entry?/1) ->
      #   Map.update!(game, :turn_manager, &TurnManager.next_turn/1)
      # true ->  Map.update!(game, :turn_manager, &TurnManager.next_phase/1)
    end
  end

end
