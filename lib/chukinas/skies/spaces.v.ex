defmodule Chukinas.Skies.ViewModel.Spaces do

  alias Chukinas.Skies.Game.Spaces, as: G_Spaces
  alias Chukinas.Skies.ViewModel.Space, as: VM_Space

  # *** *******************************
  # *** TYPES

  @type t() :: [VM_Space.t()]

  # *** *******************************
  # *** BUILD

  @spec build(G_Spaces.t()) :: t()
  def build(spaces) do
    spaces
    |> Enum.map(&VM_Space.build/1)
  end

end
