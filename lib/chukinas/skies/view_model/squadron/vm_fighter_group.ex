defmodule Chukinas.Skies.ViewModel.FighterGroup do
  alias Chukinas.Skies.Game.{Fighter, FighterGroup}
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter

  defstruct [
    :id,
    :fighters,
    :starting_location,
    :state,
    :tags,
  ]

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

  @spec build(FighterGroup.t(), integer()) :: t()
  def build(group, avail_tp) do
    [f | _] = fighters = group.fighters
    %__MODULE__{
      id: group.id,
      starting_location: f.start_turn_location,
      fighters: Enum.map(fighters, &VM_Fighter.build/1),
      state: group.state,
      tags: [] |> maybe_delay_entry(f, avail_tp)
    }
  end

  @spec maybe_delay_entry(vm_tags(), Fighter.t(), integer()) :: vm_tags()
  def maybe_delay_entry(current_tags, fighter, avail_tp) do
    if fighter.start_turn_location == :not_entered && avail_tp > 0 do
      [:delay_entry | current_tags]
    else
      current_tags
    end
  end

end
