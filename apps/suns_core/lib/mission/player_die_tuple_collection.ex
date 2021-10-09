defmodule SunsCore.Mission.PlayerDieTuple.Collection do

  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.PlayerDieTuple

  # *** *******************************
  # *** TYPES

  @type t :: [PlayerDieTuple.t]
  # TODO extract
  @type roll :: (die_side_count :: integer -> float)
  @type player_id :: integer

  # *** *******************************
  # *** CONSTRUCTORS

  @spec from_helms([Helm.t]) :: t
  def from_helms(helms) do
    helms
    |> Enum.sort_by(&Helm.id/1)
    |> Enum.map(&PlayerDieTuple.from_helm/1)
  end

  # *** *******************************
  # *** REDUCERS

  @spec roll_then_return_lowest(t, roll) :: t
  defp roll_then_return_lowest(player_die_tuples, roll) do
    {_die_roll, player_die_tuples} =
      player_die_tuples
      |> Enum.group_by(fn {_id, die} -> roll.(die) end)
      |> Enum.min_by(fn {die_roll, _player_die_tuples} -> die_roll end)
    player_die_tuples
  end

  # *** *******************************
  # *** CONVERTERS

  @spec player_id_with_best_roll(t, roll) :: player_id
  def player_id_with_best_roll([{id, _die}], _roll), do: id
  def player_id_with_best_roll(player_die_tuples, roll) do
    player_die_tuples
    |> roll_then_return_lowest(roll)
    |> player_id_with_best_roll(roll)
  end

end
