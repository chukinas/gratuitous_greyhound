defmodule Chukinas.Skies.Game.FighterGroup do
  alias Chukinas.Skies.Game.{Fighter}

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :fighters,
    :state,
  ]

  @type fighters :: [Fighter.t()]
  @type fighter_func :: (Fighter.t() -> Fighter.t())

  @type t :: %__MODULE__{
    id: integer(),
    fighters: fighters(),
    state: Fighter.state()
  }


  # *** *******************************
  # *** NEW

  @spec build_groups(fighters()) :: [t()]
  def build_groups(fighters) do
    fighters
    |> Enum.group_by(&({&1.start_turn_location, &1.move_location, &1.state}))
    |> Map.values()
    |> Enum.map(&build/1)
  end

  @spec build(fighters()) :: t()
  def build([f | _] = fighters) do
    id = fighters
    |> Enum.map(&(&1.id))
    |> Enum.min()
    %__MODULE__{
      id: id,
      fighters: fighters,
      state: f.state
    }
  end

  # *** *******************************
  # *** API

  @spec selected?(t()) :: boolean()
  def selected?(group), do: group.state == :selected

  @spec select(t()) :: t()
  def select(group) do
    state = case group.state do
      :not_avail -> :not_avail
      _ -> :selected
    end
    fighters = update_all_in_place(group.fighters, &Fighter.select/1)
    %{group | state: state, fighters: fighters}
  end

  @spec unselect(t()) :: t()
  def unselect(group) do
    state = case group.state do
      :selected -> :pending
      _ -> group.state
    end
    fighters = update_all_in_place(group.fighters, &Fighter.unselect/1)
    %{group | state: state, fighters: fighters}
  end

  @spec get_fighters(t()) :: fighters()
  def get_fighters(group) do
    group.fighters
  end

  @spec toggle_fighter_select(t(), integer()) :: t()
  def toggle_fighter_select(group, fighter_id) do
    group.fighters
    |> update_in_place(fighter_id, &Fighter.toggle_select/1)
    |> update_group(group)
  end

  @spec delay_entry(t()) :: t()
  def delay_entry(group) do
    group.fighters
    |> update_selected_in_place(&Fighter.delay_entry/1)
    |> update_group(group)
  end

  # *** *******************************
  # *** HELPERS

  @spec update_group(fighters(), t()) :: t()
  def update_group(fighters, group) do
    %{group | fighters: fighters}
  end

  defp update_selected_in_place(fighters, fun) do
    Enum.map(fighters, fn f ->
      if Fighter.selected?(f) do
        fun.(f)
      else
        f
      end
    end)
  end

  @spec update_all_in_place(fighters(), fighter_func()) :: fighters()
  defp update_all_in_place(fighters, fun) do
    update_in_place(fighters, 0, fun)
  end

  @spec update_in_place(fighters(), integer(), fighter_func()) :: fighters()
  defp update_in_place(fighters, fighter_id, fun) do
    Enum.map(fighters, fn fighter ->
      if fighter.id == fighter_id do
        fun.(fighter)
      else
        fighter
      end
    end)
  end

end
