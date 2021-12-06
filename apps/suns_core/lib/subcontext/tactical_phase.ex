defmodule SunsCore.Subcontext.TacticalPhase do

  @derive [SunsCore.Subcontext]

  use Util.GetterStruct
  alias SunsCore.Context
  alias SunsCore.Mission.Order
  alias SunsCore.Mission.PlayerOrderTracker

  # *** *******************************
  # *** TYPES

  getter_struct do
    field :player_order_tracker, PlayerOrderTracker.t
    field :orders, [Order.t], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(%Context{} = ctx) do
    active_player_id = 1
    player_order_tracker =
      ctx
      |> Context.helms
      |> PlayerOrderTracker.new(active_player_id)
    %__MODULE__{player_order_tracker: player_order_tracker}
  end

  # *** *******************************
  # *** REDUCERS

  def complete_current_order(%__MODULE__{
    orders: [current_order | completed_orders]
  } = subcontext) do
    orders = [Order.complete(current_order) | completed_orders]
    struct!(subcontext, orders: orders)
  end

  # *** *******************************
  # *** CONVERTERS

end
