defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{Fighter, FighterGroup}

  # *** *******************************
  # *** TYPES

  @type group_id :: integer()

  @type t :: %{group_id() => FighterGroup.t()}

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    new_groups = 1..3
    |> Enum.map(&Fighter.new/1)
    |> FighterGroup.build_groups()
    IO.inspect(new_groups)
    group_list_to_map(new_groups)
  end

  # *** *******************************
  # *** API

  @spec select_group(t(), integer()) :: t()
  def select_group(squadron, group_id) do
    squadron
    |> to_group_list()
    |> Enum.map(&FighterGroup.unselect/1)
    |> group_list_to_map()
    |> Map.update!(group_id, &FighterGroup.select/1)
  end

  @spec toggle_fighter_select(t(), integer()) :: t()
  def toggle_fighter_select(squadron, fighter_id) do
    squadron
    |> get_selected_group()
    |> FighterGroup.toggle_fighter_select(fighter_id)
    |> update_squadron(squadron)
  end

  @spec delay_entry(t()) :: t()
  def delay_entry(squadron) do
    squadron
    |> get_selected_group()
    |> FighterGroup.delay_entry()
    |> update_squadron(squadron)
  end

  @spec all_fighters_delayed_entry?(t()) :: boolean()
  def all_fighters_delayed_entry?(squadron) do
    squadron
    |> get_all_fighters()
    |> Enum.all?(&Fighter.delayed_entry?/1)
  end

  def any?(squadron, fun), do: Enum.any?(squadron, fun)

  @spec group_list_to_map(t()) :: [FighterGroup.t()]
  def to_group_list(squadron) do
    Map.values(squadron)
  end

  # *** *******************************
  # *** HELPERS

  @spec group_list_to_map([FighterGroup.t()]) :: t()
  defp group_list_to_map(groups) do
    groups
    |> Enum.map(&build_tuple/1)
    |> Map.new()
  end

  @spec build_tuple(FighterGroup.t()) :: {integer(), FighterGroup.t()}
  defp build_tuple(group) do
    {group.id, group}
  end

  @spec get_selected_group(t()) :: FighterGroup.t()
  defp get_selected_group(squadron) do
    squadron
    |> to_group_list()
    |> Enum.find(&FighterGroup.selected?/1)
  end

  @spec update_squadron(FighterGroup.t(), t()) :: t()
  defp update_squadron(group, squadron) do
    %{squadron | group.id => group}
  end

  @spec get_all_fighters(t()) :: [Fighter.t()]
  defp get_all_fighters(squadron) do
    squadron
    |> to_group_list()
    |> Enum.map(&FighterGroup.get_fighters/1)
    |> Enum.concat()
  end

end
