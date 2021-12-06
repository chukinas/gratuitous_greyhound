defmodule SunsCore.Subcontext.PassiveAttacksStep do

  @derive [SunsCore.Subcontext]

  use Util.GetterStruct
  alias SunsCore.Mission.Attack
  alias SunsCore.Context
  alias SunsCore.Mission.PlayerOrderTracker
  require Logger

  # *** *******************************
  # *** TYPES

  getter_struct do
    field :player_order_tracker, PlayerOrderTracker.t
    field :avail_attacks, [Attack.t]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(%Context{} = ctx) do
    active_player_id = 1
    player_order_tracker =
      ctx
      |> Context.helms
      |> PlayerOrderTracker.new(active_player_id)
    %__MODULE__{
      player_order_tracker: player_order_tracker,
      avail_attacks: []
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
