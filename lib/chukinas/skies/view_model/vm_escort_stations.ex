defmodule Chukinas.Skies.ViewModel.EscortStations do

  alias Chukinas.Skies.Game.EscortStation, as: G_EscortStation
  alias Chukinas.Skies.Game.Escorts, as: G_Escorts
  alias Chukinas.Skies.ViewModel.Box, as: VM_Box
  alias Chukinas.Skies.ViewModel.EscortStation, as: VM_EscortStation

  # *** *******************************
  # *** TYPES

  @type t() :: [VM_Box.t()]

  # *** *******************************
  # *** BUILD

  @spec build(G_Escorts.t()) :: t()
  def build(escorts) do
    G_EscortStation.box_names()
    |> Enum.map(&VM_Box.build_escort_station(&1, escorts))
  end

end
