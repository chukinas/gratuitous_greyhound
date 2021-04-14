alias Chukinas.Dreadnought.{PlayerTurn}

defmodule PlayerTurn do
  @moduledoc """
  Holds the information needed to a single player taking his turn
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :current_unit, Unit.t(), enforce: false
    field :my_other_units, [Unit.t()], default: []
    field :not_my_units, [Unit.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(mission) do
    {[current_unit], my_other_units} =
      mission.units
      |> Enum.split(1)
    %__MODULE__{
      current_unit: current_unit,
      my_other_units: my_other_units
    }
  end
end
