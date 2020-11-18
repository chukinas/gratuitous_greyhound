defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{Squadron, TacticalPoints, TurnManager}

  # TODO add defaults
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

end
