defmodule Chukinas.Skies.ViewModel.FighterGroup do
  alias Chukinas.Skies.Game.{Fighter, FighterGroup}
  alias Chukinas.Skies.ViewModel.Fighter, as: VM_Fighter
  import Chukinas.Skies.Game.IdAndState

  defstruct [
    :id,
    :fighters,
    :starting_location,
    :state,
    :tags,
    :selectable,
    :can_delay_entry,
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
    # TODO ref id and state util
    state: :not_avail | :pending | :selected | :complete,
    tags: vm_tags(),
    # TODO rename can_select
    selectable: boolean(),
    can_delay_entry: boolean(),
    # attack_space: String.t(),
    # end_turn_location: String.t(),
    # action_required: boolean(),
    # complete: boolean()
  }

  @spec build(FighterGroup.t(), [Fighter.t()], integer()) :: t()
  def build(group, all_fighters, avail_tp) do
    [f | _] = fighters = group.fighter_ids
    |> get_items(all_fighters)
    %__MODULE__{
      id: group.id,
      starting_location: f.start_turn_location,
      fighters: Enum.map(fighters, &VM_Fighter.build/1),
      state: group.state,
      tags: [],
      selectable: Enum.member?([:pending, :complete], group.state),
      can_delay_entry: can_delay_entry?(group, all_fighters, avail_tp),
    }
  end

  @spec can_delay_entry?(FighterGroup.t(), [Fighter.t()], integer()) :: boolean()
  def can_delay_entry?(group, all_fighters, avail_tp) do
    cond do
      !selected?(group) -> false
      avail_tp > 0 -> true
      Enum.any?(all_fighters, &Fighter.delayed_entry?/1) -> true
      true -> false
    end
  end

end
