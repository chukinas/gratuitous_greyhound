defmodule SunsCore.Mission.PlayerDieTuple do

  alias SunsCore.Mission.Helm

  # *** *******************************
  # *** TYPES

  @type t :: {player_id :: integer, die_sides :: integer}

  # *** *******************************
  # *** CONSTRUCTORS

  @spec from_helm(Helm.t) :: t
  def from_helm(%Helm{} = helm), do: {Helm.id(helm), Helm.initiative_rolloff_die(helm)}

end
