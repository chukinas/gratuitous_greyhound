defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{Fighter, FighterGroup}
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
    squadron = 1..2
    |> Enum.map(&Fighter.new/1)
    |> rebuild()
    group = squadron.groups
    |> Enum.at(0)
    |> FighterGroup.select()
    %{squadron | groups: [group]}
  end

  @spec build([Fighter.t()], [FighterGroup.t()]) :: t()
  def build(fighters, groups) do
    %__MODULE__{fighters: fighters, groups: groups}
  end

  @spec rebuild([Fighter.t()]) :: t()
  def rebuild(fighters) do
    groups = fighters
    |> Enum.map(&Fighter.unselect/1)
    |> FighterGroup.build_groups()
    build(fighters, groups)
  end

  # *** *******************************
  # *** API

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

  @spec delay_entry(t()) :: t()
  def delay_entry(squadron) do
    fighter_ids = get_selected_fighter_ids(squadron)
    squadron.fighters
    |> apply_if_matching_id(fighter_ids, &Fighter.delay_entry/1)
    |> rebuild()
  end

  def any_fighters?(squadron, fun), do: squadron.fighters |> Enum.any?(fun)
  def all_fighters?(squadron, fun), do: squadron.fighters |> Enum.all?(fun)

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
