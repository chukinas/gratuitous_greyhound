defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{
    Bomber,
    Box,
    Fighter,
    FighterGroup,
    FighterGroups,
    IdAndState,
    Phase,
  }
  import Chukinas.Skies.Game.IdAndState

  # *** *******************************
  # *** TYPES

  defstruct [
    :groups,
    :fighters,
  ]

  @type t :: %__MODULE__{
    groups: [FighterGroup.t()],
    fighters: [Fighter.t()],
  }

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    1..2
    |> Enum.map(&Fighter.new/1)
    |> build()
    |> select_group(1)
  end

  # *** *******************************
  # *** BUILD

  @spec build([Fighter.t()]) :: t()
  defp build(fighters) do
    groups = fighters
    |> Enum.map(&Fighter.unselect/1)
    |> FighterGroups.build()
    build(fighters, groups)
  end

  @spec build([Fighter.t()], [FighterGroup.t()]) :: t()
  defp build(fighters, groups) do
    %__MODULE__{fighters: fighters, groups: groups}
  end

  # *** *******************************
  # *** API, Pipeable

  @spec select_group(t(), integer()) :: t()
  def select_group(squadron, group_id) do
    groups = squadron.groups
    |> Enum.map(&FighterGroup.unselect/1)
    |> apply_if_matching_id(group_id, &FighterGroup.select/1)
    fighter_ids = groups
    |> get_item(group_id)
    |> Map.fetch!(:fighter_ids)
    fighters = squadron.fighters
    |> apply_if_matching_id(fighter_ids, &Fighter.select/1)
    build(fighters, groups)
  end

  @spec toggle_fighter_select(t(), integer()) :: t()
  def toggle_fighter_select(squadron, fighter_id) do
    squadron.fighters
    |> apply_if_matching_id(fighter_id, &Fighter.toggle_select/1)
    |> update_fighters(squadron)
  end

  @spec do_not_move(t()) :: t()
  def do_not_move(squadron) do
    fighter_ids = get_selected_fighter_ids(squadron)
    squadron.fighters
    |> apply_if_matching_id(fighter_ids, &Fighter.do_not_move/1)
    |> build()
  end

  @spec move(t(), Box.id()) :: t()
  def move(squadron, box_id) do
    fighter_ids = get_selected_fighter_ids(squadron)
    squadron.fighters
    |> apply_if_matching_id(fighter_ids, &Fighter.move(&1, box_id))
    |> build()
  end

  @spec next_turn(t()) :: t()
  def next_turn(%__MODULE__{} = s) do
    s.fighters
    |> Enum.map(&Fighter.next_turn/1)
    |> build()
  end

  @spec attack(t(), Bomber.id()) :: t()
  def attack(squadron, bomber_id) do
    fighter_ids = get_selected_fighter_ids(squadron)
    squadron.fighters
    |> apply_if_matching_id(fighter_ids, &Fighter.attack(&1, bomber_id))
    |> build()
  end

  @spec start_phase(t(), Phase.phase_name()) :: t()
  def start_phase(s, phase_name) do
    s.fighters
    |> Enum.map(&Fighter.set_phase(&1, phase_name))
    |> build()
  end

  # *** *******************************
  # *** API, Other

  def get_unique_moves(%__MODULE__{fighters: fighters}) do
    fighters
    |> Enum.map(&Fighter.get_move/1)
    |> Enum.uniq()
  end
  def any_fighters?(squadron, fun), do: squadron.fighters |> Enum.any?(fun)
  def all_fighters?(squadron, fun), do: squadron.fighters |> Enum.all?(fun)
  def done?(squadron), do: all_fighters?(squadron, &IdAndState.done?/1)

  # *** *******************************
  # *** HELPERS

  @spec update_fighters([Fighter.t()], t()) :: t()
  defp update_fighters(fighters, squadron) do
    %{squadron | fighters: fighters}
  end

  defp get_selected_fighter_ids(squadron) do
    squadron.groups
    |> get_single_selected()
    |> Map.fetch!(:fighter_ids)
    |> get_items(squadron.fighters)
    |> get_selected()
    |> get_list_of_ids()
  end

end
