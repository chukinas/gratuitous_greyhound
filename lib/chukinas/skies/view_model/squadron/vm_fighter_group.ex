defmodule Chukinas.Skies.ViewModel.FighterGroup do
  alias Chukinas.Skies.Game.{Fighter, FighterGroup, IdAndState}
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter

  defstruct [
    :id,
    :fighters,
    :starting_location,
    :state,
    :tags,
    :can_select?,
    :can_delay_entry?,
    :selected?,
    :done?,
  ]

  def compare(s1, s2) do
    cond do
      s1.id > s2.id -> :gt
      s1.id < s2.id -> :lt
      true -> :eq
    end
  end

  @type vm_fighter :: VM_Fighter.t()

  @type vm_tags :: []

  @type t :: %__MODULE__{
    id: integer(),
    fighters: [vm_fighter()],
    starting_location: String.t(),
    state: IdAndState.state(),
    tags: vm_tags(),
    can_select?: boolean(),
    can_delay_entry?: boolean(),
    selected?: boolean(),
    done?: boolean(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(FighterGroup.t(), [Fighter.t()], integer()) :: t()
  def build(group, all_fighters, avail_tp) do
    [f | _] = fighters = group.fighter_ids
    |> IdAndState.get_items(all_fighters)
    %__MODULE__{
      id: group.id,
      starting_location: f.start_turn_location,
      fighters: Enum.map(fighters, &VM_Fighter.build/1),
      state: group.state,
      tags: [],
      can_select?: Enum.member?([:pending, :complete], group.state),
      can_delay_entry?: can_delay_entry?(group, all_fighters, avail_tp),
      selected?: group.state == :selected,
      done?: IdAndState.done?(group)
    }
  end

  # *** *******************************
  # *** API

  @spec can_delay_entry?(FighterGroup.t(), [Fighter.t()], integer()) :: boolean()
  def can_delay_entry?(group, all_fighters, avail_tp) do
    cond do
      !IdAndState.selected?(group) -> false
      avail_tp > 0 -> true
      Enum.any?(all_fighters, &Fighter.delayed_entry?/1) -> true
      true -> false
    end

  end

end
