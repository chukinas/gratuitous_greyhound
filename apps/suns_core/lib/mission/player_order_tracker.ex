defmodule SunsCore.Mission.PlayerOrderTracker do

  # alias SunsCore.DieRoller
  # alias SunsCore.Mission.PlayerDieTuple.Collection, as: PlayerDieTuples
  alias SunsCore.Mission.Helm.Collection, as: Helms

  # *** *******************************
  # *** TYPES

  @type player_id :: integer

  use Util.GetterStruct
  getter_struct do
    # TODO I think these first three don't belong here...
    # They don't fit with e.g. passive attacks step
    # field :player_id_with_initiative, player_id
    # defaults to player with initiative
    # field :start_player_id, player_id
    # field :start_player_chosen?, boolean, default: false
    field :current_player_id, player_id, enforce: false
    field :other_avail_player_ids, player_id, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  #def new(helms, rand_num_gen) do
  #  die_roller = DieRoller.new_initialized(rand_num_gen)
  #  roll = fn sides -> DieRoller.roll(die_roller, sides) end
  #  player_id_with_initiative =
  #    helms
  #    |> PlayerDieTuples.from_helms
  #    |> PlayerDieTuples.player_id_with_best_roll(roll)
  #  %__MODULE__{
  #    player_id_with_initiative: player_id_with_initiative,
  #    start_player_id: player_id_with_initiative
  #  }
  #end

  def new(helms, start_player_id) do
    helms
    |> Helms.sorted_player_ids_starting_with(start_player_id)
    |> do_new
  end

  #def new_passive_attacks_tracker(helms, active_player_id) do
  #  [_active_player_id | [current_player_id | other_avail_player_ids]] =
  #    Helms.sorted_player_ids_starting_with(helms, active_player_id)
  #  %__MODULE__{
  #    current_player_id: current_player_id,
  #    other_avail_player_ids: other_avail_player_ids
  #  }
  #end

  defp do_new([current_player_id | other_avail_player_ids]) do
    %__MODULE__{
      current_player_id: current_player_id,
      other_avail_player_ids: other_avail_player_ids
    }
  end

  # *** *******************************
  # *** REDUCERS

  def goto_next_player(%__MODULE__{} = tracker) do
    case other_avail_player_ids(tracker) ++ List.wrap(current_player_id(tracker)) do
      [] -> [nil]
      player_ids -> player_ids
    end
    |> do_new
  end

  def drop_player_by_id(%__MODULE__{current_player_id: current_player_id} = tracker, player_id) do
    current_player_id =
      if current_player_id == player_id do
        nil
      else
        current_player_id
      end
    other_avail_player_ids =
      tracker
      |> other_avail_player_ids
      |> Enum.reject(& &1 == player_id)
    do_new [current_player_id | other_avail_player_ids]
  end

  # *** *******************************
  # *** CONVERTERS

  def complete?(%__MODULE__{current_player_id: nil, other_avail_player_ids: []}), do: true
  def complete?(_), do: false

end

# TODO
# This needs to be able to ...
# Keep track of turn order?
#   i.e. who's next in clockwise order
# Who is currently active player?
#
