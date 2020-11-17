defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{Squadron, TurnManager}

  @type t :: %{
    spaces: any(),
    elements: any(),
    boxes: any(),
    squadron: any(),
    turn_manager: TurnManager.t()
  }

  def init(map_id) do
    state = Spec.build(map_id)
    %{
      spaces: state.spaces,
      elements: state.elements,
      boxes: state.boxes,
      squadron: Squadron.new(),
      turn_manager: TurnManager.init()
    }
  end

end
