defmodule Chukinas.Skies.ViewModel.Squadron do
  alias Chukinas.Skies.Game.{Squadron}
  alias Chukinas.Skies.ViewModel.TacticalPoints
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter
  alias Chukinas.Skies.ViewModel.FighterGroup, as: VM_FighterGroup

  defstruct [
    :current_tp,
    :groups,
  ]

  @type g_fighters :: Squadron.fighters()

  @type vm_fighter :: VM_Fighter.t()

  @type t :: %__MODULE__{
    current_tp: integer(),
    groups: [VM_FighterGroup.t()],
    # groups: [vm_group()],
    # action_required: boolean(),
    # complete: boolean()
  }

  @spec build(Squadron.t(), TacticalPoints.t()) :: t()
  def build(squadron, tactical_points) do
    # vm_groups = fighters
    # |> Squadron.group()
    # |> Enum.map(&build_group/1)
    avail_tp = tactical_points.avail
    %__MODULE__{
      # TODO rename available tp?
      current_tp: avail_tp,
      groups: squadron
        |> Enum.group_by(&(&1.group_id))
        |> Enum.map(&(VM_FighterGroup.build(&1, avail_tp))),
      # groups: vm_groups,
      # action_required: false,
      # complete: false
    }
  end

end
