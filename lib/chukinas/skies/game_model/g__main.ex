defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{Fighter, TurnManager}

  @type t :: %{
    spaces: any(),
    elements: any(),
    boxes: any(),
    fighters: any(),
    turn_manager: TurnManager.t()
  }

  def init(map_id) do
    # TODO rename do be something like Spec.Map.build...
    state = Spec.build(map_id)
    %{
      spaces: state.spaces,
      elements: state.elements,
      boxes: state.boxes,
      fighters: Enum.map(0..2, &Fighter.new/1),
      turn_manager: TurnManager.init()
    }
  end

end
