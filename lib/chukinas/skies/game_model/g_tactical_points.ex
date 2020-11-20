defmodule Chukinas.Skies.Game.TacticalPoints do
  alias Chukinas.Skies.Game.{Fighter, Squadron}

  defstruct [
    :starting,
    :spent,
  ]

  @type t :: %__MODULE__{
    starting: integer(),
    spent: integer(),
  }

  def new() do
    %__MODULE__{
      starting: 1,
      spent: 0,
    }
  end

  # @spec calculate(t(), Squadron.t()) :: t()
  def calculate(%__MODULE__{} = tp, %Squadron{} = squadron) do

    any_delayed_entries? = squadron.fighters
    |> Enum.any?(&Fighter.delayed_entry?/1)
    spent = if any_delayed_entries?, do: 1, else: 0

    # spent = spent + case Squadron.any_fighters?(
    #   squadron,
    #   &Fighter.delayed_entry?/1
    # ) do
    #   true -> 1
    #   false -> 0
    # end
    %{tp | spent: spent}
  end

end
