defmodule Chukinas.Skies.ViewModel.FighterGroup do
  alias Chukinas.Skies.Game.{Squadron}
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter

  defstruct [
    :id,
    :fighters,
    :starting_location,
    :state,
    :tags,
  ]

  @type g_fighters :: Squadron.fighters()

  @type vm_fighter :: VM_Fighter.t()

  @type vm_tags :: [:delay_entry] | []

  @type t :: %__MODULE__{
    id: integer(),
    fighters: [vm_fighter()],
    starting_location: String.t(),
    state: :not_avail | :pending | :selected | :complete,
    tags: vm_tags(),
    # attack_space: String.t(),
    # end_turn_location: String.t(),
    # action_required: boolean(),
    # complete: boolean()
  }

  @spec build({integer(), g_fighters()}, integer()) :: t()
  def build({group_id, [f | _] = group}, avail_tp) do
    %__MODULE__{
      id: group_id,
      starting_location: f.start_turn_location,
      fighters: Enum.map(group, &VM_Fighter.build/1),
      state: f.state,
      tags: [] |> maybe_delay_entry(f, avail_tp)
    }
  end

  @spec maybe_delay_entry(vm_tags(), Squadron.fighter(), integer()) :: vm_tags()
  def maybe_delay_entry(current_tags, fighter, avail_tp) do
    if fighter.start_turn_location == :not_entered && avail_tp > 0 do
      [:delay_entry | current_tags]
    else
      current_tags
    end
  end

end
