defmodule Chukinas.Skies.Game.TacticalPoints do
  alias Chukinas.Skies.Game.{Boxes, Fighter, Squadron}

  defstruct [
    :starting,
    # TODO rename spent_this_phase this phase
    :spent_this_phase,
    :spent_committed,
  ]

  @type t :: %__MODULE__{
    starting: integer(),
    spent_this_phase: integer(),
    spent_committed: integer(),
  }

  def new() do
    %__MODULE__{
      starting: 1,
      # TODO vm has to add these two up
      spent_this_phase: 0,
      spent_committed: 0
    }
  end

  # TODO reimplement spec - use spec from box or boxes?
  # @spec calculate(t(), Squadron.t(), [Boxes.t()]) :: t()
  # TODO rename calculate move costs
  def calculate(%__MODULE__{} = tp, %Squadron{} = squadron, boxes) do
    spent_this_phase = squadron
    |> Squadron.get_unique_moves()
    |> Enum.map(&Boxes.get_move_cost(boxes, &1))
    |> Enum.sum()
    %{tp | spent_this_phase: spent_this_phase}
  end

  # TODO spec
  def commit_spent_point(%__MODULE__{} = tp) do
    %{tp | spent_this_phase: 0, spent_committed: tp.spent_this_phase + tp.spent_committed}
  end

end
