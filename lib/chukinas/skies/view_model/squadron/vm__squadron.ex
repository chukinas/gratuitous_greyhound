defmodule Chukinas.Skies.ViewModel.Squadron do
  alias Chukinas.Skies.Game.{Squadron}
  alias Chukinas.Skies.ViewModel.TacticalPoints, as: VM_TacticalPoints
  alias Chukinas.Skies.ViewModel.FighterGroup, as: VM_FighterGroup

  # *** *******************************
  # *** TYPES

  defstruct [
    :avail_tp,
    :done?,
    :groups,
  ]

  @type t :: %__MODULE__{
    avail_tp: integer(),
    done?: boolean(),
    groups: [VM_FighterGroup.t()],
  }

  # *** *******************************
  # *** NEW

  @spec build(Squadron.t(), VM_TacticalPoints.t()) :: t()
  def build(g_squadron, vm_tactical_points) do
    avail_tp = vm_tactical_points.avail
    groups = g_squadron.groups
    |> Enum.map(&(VM_FighterGroup.build(&1, g_squadron.fighters, avail_tp)))
    |> Enum.sort(VM_FighterGroup)
    %__MODULE__{
      avail_tp: avail_tp,
      done?: can_end_phase?(groups),
      groups: groups,
    }
  end

  # *** *******************************
  # *** VIEW MODEL

  def can_end_phase?(groups) do
    groups |> Enum.all?(&(&1.done?))
  end

end
