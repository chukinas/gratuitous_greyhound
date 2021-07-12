alias Chukinas.Dreadnought.Unit

defmodule Unit.Enum do

  def active_units(units) do
    units
    |> Stream.filter(& &1 |> Unit.status |> Unit.Status.active?)
  end

  def active_player_units(units, player_id) do
    units
    |> active_units
    |> Stream.filter(&Unit.belongs_to?(&1, player_id))
  end

  def active_player_unit_count(units, player_id) do
    units
    |> active_player_units(player_id)
    |> Enum.count
  end

  def active_player_unit_ids(units, player_id) do
    units
    |> active_player_units(player_id)
    # TODO can this be a stream?
    |> Enum.map(& &1.id)
  end

  def enemy_unit_ids(units, player_id) do
    units
    |> active_units
    |> Stream.filter(& !Unit.belongs_to?(&1, player_id))
    # TODO can this be a stream?
    |> Enum.map(& &1.id)
  end
end
