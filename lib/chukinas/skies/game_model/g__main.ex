defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{
    Box,
    Boxes,
    Fighter,
    Positions,
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
    state = Spec.build(map_id)
    %__MODULE__{
      spaces: state.spaces,
      elements: state.elements,
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

  def delay_entry(%__MODULE__{
    squadron: s,
    tactical_points: tp
  } = game) do
    s = Squadron.delay_entry(s)
    tp = TacticalPoints.calculate(tp, s)
    %{game | squadron: s, tactical_points: tp}
  end

  def select_box(%__MODULE__{} = game, location) when is_binary(location) do
    location
    |> Box.id_from_string()
    # TODO JJC temp
    game
  end

  @spec end_phase(t()) :: t()
  def end_phase(%__MODULE__{squadron: s, turn_manager: tm} = game) do
    cond do
      !Squadron.done?(s) -> game
      !TurnManager.current_phase?(tm, :move) ->
        Map.update!(game, :turn_manager, &TurnManager.next_phase/1)
      Squadron.all_fighters?(s, &Fighter.delayed_entry?/1) ->
        Map.update!(game, :turn_manager, &TurnManager.next_turn/1)
      true ->  Map.update!(game, :turn_manager, &TurnManager.next_phase/1)
    end
  end

end
