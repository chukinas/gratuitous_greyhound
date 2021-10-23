defmodule SunsCore.Event.TacticalPhase.IssueOrder do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Order

  # *** *******************************
  # *** TYPES

  event_struct do
    field :order, Order.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Order.t) :: t
  def new(order) do
    %__MODULE__{
      order: order
    }
  end

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** CALLBACKS

end
