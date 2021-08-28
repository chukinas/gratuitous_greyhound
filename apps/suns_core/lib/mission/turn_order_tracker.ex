defmodule SunsCore.Mission.TurnOrderTracker do

  alias SunsCore.DieRoller
  alias SunsCore.Mission.Helm

  # *** *******************************
  # *** SUBMODULES

  defmodule PlayerDieTuples do
    # TYPES
    @type t :: [{player_id :: integer, die_sides :: integer}]
    # CONSTRUCTORS
    @spec from_helms([Helm.t]) :: t
    def from_helms(helms) do
      helms
      |> Enum.sort_by(&Helm.id/1)
      |> Stream.map(&{Helm.id(&1), Helm.initiative_rolloff_die(&1)})
    end
    # REDUCERS
    @spec single_roll_off(t, (integer -> float)) :: t
    defp single_roll_off(tuples, roll) do
      {_die_roll, player_die_tuples} =
        tuples
        |> Enum.group_by(fn {_id, die} -> roll.(die) end)
        |> Enum.min_by(fn {die_roll, _player_die_tuples} -> die_roll end)
      player_die_tuples
    end
    # CONVERTERS
    @spec player_id_with_best_roll(t, (integer -> integer)) :: player_id :: integer
    def player_id_with_best_roll([{id, _die}], _roll), do: id
    def player_id_with_best_roll(tuples, roll) do
      tuples
      |> single_roll_off(roll)
      |> player_id_with_best_roll(roll)
    end
  end

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :player_id_with_initiative, integer
    field :start_player, integer, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(helms, rand_num_gen) do
    die_roller = DieRoller.new_initialized(rand_num_gen)
    roll = fn sides -> DieRoller.roll(die_roller, sides) end
    player_id_with_initiative =
      helms
      |> PlayerDieTuples.from_helms
      |> PlayerDieTuples.player_id_with_best_roll(roll)
    %__MODULE__{
      player_id_with_initiative: player_id_with_initiative,
    }
  end

  # *** *******************************
  # *** CONVERTERS

end
