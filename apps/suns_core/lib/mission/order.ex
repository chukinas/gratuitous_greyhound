defmodule SunsCore.Mission.Order do

  alias SunsCore.Mission.GlobalId

  # *** *******************************
  # *** TYPES

  @type valid_order :: :vector | {:engage, target :: GlobalId.t} | :red_alert | :jump_out
  @type valid_order_name :: :vector | :engage | :red_alert | :jump_out

  @valid_order_name ~w/vector red_alert jump_out engage/a

  use Util.GetterStruct
  getter_struct do
    field :battlegroup_id, integer
    field :order, valid_order
    field :complete?, boolean, default: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  for order <- ~w/vector red_alert jump_out/a do
    def unquote(order)(battlegroup_id) do
      %__MODULE__{
        battlegroup_id: battlegroup_id,
        order: unquote(order)
      }
    end
  end

  @spec engage(integer, GlobalId.t) :: t
  def engage(battlegroup_id, target) do
    %__MODULE__{
      battlegroup_id: battlegroup_id,
      order: {:engage, target}
    }
  end

  # *** *******************************
  # *** REDUCERS

  @spec complete(t) :: t
  def complete(%__MODULE__{} = order) do
    struct!(order, complete?: true)
  end

  # *** *******************************
  # *** CONVERTERS

  def symbol(%__MODULE__{order: {symbol, _}}), do: symbol
  def symbol(%__MODULE__{order: symbol}), do: symbol

  def is(%__MODULE__{} = order, order_symbol) when order_symbol in @valid_order_name do
    order_symbol === symbol(order)
  end

end
