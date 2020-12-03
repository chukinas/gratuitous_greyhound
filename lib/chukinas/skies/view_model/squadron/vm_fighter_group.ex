defmodule Chukinas.Skies.ViewModel.FighterGroup do

  alias Chukinas.Skies.Game.{Fighter, FighterGroup, IdAndState}
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter
  alias Chukinas.Skies.ViewModel.Location, as: VM_Location

  def compare(s1, s2) do
    cond do
      s1.id > s2.id -> :gt
      s1.id < s2.id -> :lt
      true -> :eq
    end
  end

  @type vm_fighter :: VM_Fighter.t()

  @type vm_tags :: []

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :fighters, [vm_fighter()]
    field :starting_location, String.t()
    field :ending_location, String.t()
    field :state, IdAndState.state()
    field :tags, vm_tags()
    field :can_select?, boolean()
    field :can_delay_entry?, boolean()
    field :selected?, boolean()
    field :done?, boolean()
  end

  # *** *******************************
  # *** BUILD

  @spec build(FighterGroup.t(), [Fighter.t()], integer()) :: t()
  def build(group, all_fighters, avail_tp) do
    [f | _] = fighters = group.fighter_ids
    |> IdAndState.get_items(all_fighters)
    %__MODULE__{
      id: group.id,
      starting_location: VM_Location.to_friendly_string(f.from_location),
      ending_location: VM_Location.to_friendly_string(f.to_location),
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
