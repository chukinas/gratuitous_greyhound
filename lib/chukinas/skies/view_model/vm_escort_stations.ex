defmodule Chukinas.Skies.ViewModel.EscortStations do

  alias Chukinas.Skies.ViewModel.EscortStation

  # *** *******************************
  # *** TYPES

  @type t() :: [EscortStation.t()]

  # *** *******************************
  # *** BUILD

  # @spec build(G_EscortStations.t()) :: t()
  @spec build() :: t()
  def build() do
    ~w[abovetrailing forward belowtrailing]
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(&EscortStation.build/1)
  end


end

# TODO move to new file
defmodule Chukinas.Skies.ViewModel.EscortStation do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :title, String.t()
    field :escort_pawns, [EscortPawn.t()]
  end

  # *** *******************************
  # *** BUILD

  @spec build(atom()) :: t()
  def build(name) do
    %__MODULE__{
      title: name |> Atom.to_string() |> String.capitalize(),
      escort_pawns: [],
    }
  end


end
