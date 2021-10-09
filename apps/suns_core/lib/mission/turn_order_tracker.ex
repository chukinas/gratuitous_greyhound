defmodule SunsCore.Mission.TurnOrderTracker do

  alias SunsCore.DieRoller
  alias SunsCore.Mission.PlayerDieTuple.Collection, as: PlayerDieTuples

  # *** *******************************
  # *** TYPES

  @type player_id :: integer

  use Util.GetterStruct
  getter_struct do
    field :player_id_with_initiative, player_id
    # defaults to player with initiative
    field :start_player_id, player_id
    field :start_player_chosen?, boolean, default: false
    field :next_player, nil | integer, default: nil
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
      start_player_id: player_id_with_initiative
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def get_and_update_next_player_id(tracker) do
    # TODO implement. Ok for now that I'm testing only for a single plyaer
    new_tracker = %__MODULE__{tracker | next_player: 1}
    {1, new_tracker}
  end

end
