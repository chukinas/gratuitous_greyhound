defmodule Chukinas.Skies.ViewModel.EscortStation do

  alias Chukinas.Skies.ViewModel.EscortPawn

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
