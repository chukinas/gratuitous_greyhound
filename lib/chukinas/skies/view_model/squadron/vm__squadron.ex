defmodule Chukinas.Skies.ViewModel.Squadron do
  alias Chukinas.Skies.Game.{Squadron}
  alias Chukinas.Skies.ViewModel.TacticalPoints, as: VM_TacticalPoints
  alias Chukinas.Skies.ViewModel.FighterGroup, as: VM_FighterGroup

  # *** *******************************
  # *** TYPES

  defstruct [
    :avail_tp,
    :groups,
  ]

  @type t :: %__MODULE__{
    avail_tp: integer(),
    groups: [VM_FighterGroup.t()],
  }

  # *** *******************************
  # *** NEW

  @spec build(Squadron.t(), VM_TacticalPoints.t()) :: t()
  def build(g_squadron, vm_tactical_points) do
    avail_tp = vm_tactical_points.avail
    groups = g_squadron.groups
    |> Enum.map(&(VM_FighterGroup.build(&1, g_squadron.fighters, avail_tp)))
    %__MODULE__{
      avail_tp: avail_tp,
      groups: groups,
    }
  end

end
