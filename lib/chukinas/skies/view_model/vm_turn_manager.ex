defmodule Chukinas.Skies.ViewModel.TurnManager do

  alias Chukinas.Skies.Game.Phase, as: G_Phase
  alias Chukinas.Skies.Game.Turn, as: G_Turn
  alias Chukinas.Skies.ViewModel.Phase

  # TODO rename? Progress ...?

  # *** *******************************
  # *** TYPES

  # TODO struct

  @type phase :: %{
    name: String.t(),
    # TODO the second two are confusing
    status: (:other | :in_progress | :sub_in_progress),
    maybe_current_phase_id: String.t(),
    subphases: [phase()],
  }

  # TODO struct
  @type t :: %{
    turn: integer(),
    max_turn: integer(),
    phases: [phase()],
  }

  # *** *******************************
  # *** BUILD

  @spec build(G_Turn.t(), G_Phase.t()) :: t()
  def build(turn, phase) do
    %{
      turn: turn.current,
      max_turn: turn.max_turn,
      phases: Phase.build(phase),
    }
  end

end
