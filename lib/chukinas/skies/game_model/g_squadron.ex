defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{Fighter}

  # *** *******************************
  # *** TYPES

  @type t :: [Fighter.t()]

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    1..6
    |> Enum.map(&Fighter.new/1)
  end

  # *** *******************************
  # *** API

  @spec select_group(t(), integer()) :: t()
  def select_group(squadron, group_id) do
    squadron
    |> Enum.map(&(maybe_select(&1, group_id)))
  end

  @spec toggle_fighter_select(t(), integer()) :: t()
  def toggle_fighter_select(squadron, fighter_id) do
    do_to_fighter(
      squadron,
      fighter_id,
      &Fighter.toggle_select/1
    )
  end

  defp maybe_select(fighter, group_id) do
    cond do
      fighter.group_id == group_id -> %{fighter | state: :selected}
      fighter.state == :selected -> %{fighter | state: :pending}
    end
  end

  @spec group(t()) :: [t()]
  def group(fighters) do
    fighters
    |> Enum.group_by(&({&1.start_turn_location, &1.move_location, &1.state}))
    |> Map.values()
  end

  def delay_entry(s), do: if_selected_do(s, &Fighter.delay_entry/1)

  def all_fighters_delayed_entry?(squadron) do
    Enum.all?(squadron, &Fighter.delayed_entry?/1)
  end

  def any?(squadron, fun), do: Enum.any?(squadron, fun)
  def all?(squadron, fun), do: Enum.all?(squadron, fun)

  # *** *******************************
  # *** HELPERS

  defp if_selected_do(squadron, fun) do
    Enum.map(squadron, fn f ->
      if Fighter.selected?(f) do
        fun.(f)
      else
        f
      end
    end)
  end

  # TODO rename
  defp do_to_fighter(squadron, fighter_id, fun) do
    Enum.map(squadron, fn fighter ->
      if fighter.id == fighter_id do
        fun.(fighter)
      else
        fighter
      end
    end)
  end

end
