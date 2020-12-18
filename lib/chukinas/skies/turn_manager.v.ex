defmodule Chukinas.Skies.ViewModel.TurnManager do

  alias Chukinas.Skies.Game.Phase, as: G_Phase
  alias Chukinas.Skies.Game.Turn, as: G_Turn
  alias Chukinas.Skies.ViewModel.Phase

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :turn, integer()
    field :max_turn, integer()
    field :phases, [Phase.t()]
  end

  # *** *******************************
  # *** BUILD

  @spec build(G_Turn.t(), G_Phase.t()) :: t()
  def build(turn, phase) do
    %__MODULE__{
      turn: turn.number,
      max_turn: turn.max,
      phases: Phase.build(phase),
    }
  end

end
