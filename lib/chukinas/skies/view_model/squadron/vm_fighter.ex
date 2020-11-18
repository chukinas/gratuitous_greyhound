defmodule Chukinas.Skies.ViewModel.Fighter do
  alias Chukinas.Skies.Game.{Squadron}

  defstruct [
    :id,
    :name,
    :hits,
    :airframe,
  ]

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    hits: String.t(),
    airframe: Squadron.airframe(),
  }

  @spec build(Squadron.fighter()) :: t()
  def build(fighter) do
    %__MODULE__{
      id: fighter.id,
      name: fighter.pilot_name,
      hits: rand_hits(),
      airframe: fighter.airframe,
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
