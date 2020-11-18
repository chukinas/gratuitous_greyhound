defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{Squadron, TacticalPoints, TurnManager}

  defstruct [
    :spaces,
    :elements,
    :boxes,
    :squadron,
    :turn_manager,
    :tactical_points,
  ]

  @type t :: %__MODULE__{
    spaces: any(),
    elements: any(),
    boxes: any(),
    squadron: any(),
    turn_manager: TurnManager.t(),
    tactical_points: TacticalPoints.t(),
  }

  @spec init(any()) :: t()
  def init(map_id) do
    state = Spec.build(map_id)
    %__MODULE__{
      spaces: state.spaces,
      elements: state.elements,
      boxes: state.boxes,
      squadron: Squadron.new(),
      turn_manager: TurnManager.init(),
      tactical_points: TacticalPoints.new(),
    }
  end

  # *** *******************************
  # *** API

  def delay_entry(%__MODULE__{squadron: s, turn_manager: tm, tactical_points: tp} = game) do
    s = Squadron.delay_entry(s)
    tm = cond do
      Squadron.all_fighters_delayed_entry?(s) -> TurnManager.next_turn(tm)
      true -> tm
    end
    tp = TacticalPoints.calculate(tp, s)
    %{game | squadron: s, turn_manager: tm, tactical_points: tp}
  end

end
