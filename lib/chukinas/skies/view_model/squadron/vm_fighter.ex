defmodule Chukinas.Skies.ViewModel.Fighter do
  alias Chukinas.Skies.Game.{Fighter}

  defstruct [
    :id,
    :name,
    :hits,
    :airframe,
    :selected,
  ]

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    hits: String.t(),
    airframe: Fighter.airframe(),
    selected: boolean(),
  }

  @spec build(Fighter.t()) :: t()
  def build(fighter) do
    %__MODULE__{
      id: fighter.id,
      name: fighter.pilot_name,
      hits: rand_hits(),
      airframe: fighter.airframe,
      selected: Fighter.selected?(fighter)
    }
  end

  @spec rand_hits() :: String.t()
  defp rand_hits() do
    Enum.random([
      "Fuselage",
      "Rudder",
      "Engine"
    ])
  end

end
