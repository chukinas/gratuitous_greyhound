defmodule Chukinas.Skies.ViewModel.Bombers do

  alias Chukinas.Skies.Game.Bomber, as: G_Bomber
  alias Chukinas.Skies.ViewModel.Bomber, as: VM_Bomber

  # *** *******************************
  # *** BUILD

  @spec build([G_Bomber.t()]) :: [VM_Bomber.t()]
  def build(bombers) do
    bombers
    |> Enum.map(&VM_Bomber.build/1)
  end

end
