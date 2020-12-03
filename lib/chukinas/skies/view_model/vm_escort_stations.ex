defmodule Chukinas.Skies.ViewModel.EscortStations do

  alias Chukinas.Skies.Game.Escorts, as: G_Escorts
  alias Chukinas.Skies.ViewModel.EscortStation

  # *** *******************************
  # *** TYPES

  @type t() :: [EscortStation.t()]

  # *** *******************************
  # *** BUILD

  @spec build(G_Escorts.t()) :: t()
  def build(_escorts) do
    ~w[abovetrailing forward belowtrailing]
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(&EscortStation.build/1)
    |> IO.inspect()
  end


end
