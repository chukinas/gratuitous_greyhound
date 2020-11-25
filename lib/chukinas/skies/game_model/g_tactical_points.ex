defmodule Chukinas.Skies.Game.TacticalPoints do
  alias Chukinas.Skies.Game.{Boxes, Fighter, Squadron}

  defstruct [
    :starting,
    # TODO rename spent this phase
    :spent,
    :spent_committed,
  ]

  @type t :: %__MODULE__{
    starting: integer(),
    spent: integer(),
    spent_committed: integer(),
  }

  def new() do
    %__MODULE__{
      starting: 1,
      # TODO vm has to add these two up
      spent: 0,
      spent_committed: 0
    }
  end

  # TODO reimplement spec - use spec from box or boxes?
  # @spec calculate(t(), Squadron.t(), [Boxes.t()]) :: t()
  # TODO rename calculate move costs
  def calculate(%__MODULE__{} = tp, %Squadron{} = squadron, boxes) do
    spent = squadron
    |> Squadron.get_unique_moves()
    |> Enum.map(&Boxes.get_move_cost(boxes, &1))
    |> Enum.sum()
    %{tp | spent: spent}
  end

  # TODO spec
  def commit_spent_point(%__MODULE__{} = tp) do
    %{tp | spent: 0, spent_committed: tp.spent + tp.spent_committed}
  end

end
