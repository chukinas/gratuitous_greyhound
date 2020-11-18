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

  def if_selected_do(squadron, fun) do
    Enum.map(squadron, fn f ->
      if Fighter.selected?(f) do
        fun.(f)
      else
        f
      end
    end)
    # squadron
    # |> Enum.map(&Fighter.if_selected_do(&1, fun))
  end

end
