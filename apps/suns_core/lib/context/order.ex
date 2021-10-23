defmodule SunsCore.Context.Order do

  alias SunsCore.Context
  alias SunsCore.Mission.Order

  # *** *******************************
  # *** TYPES

  @type t :: Context.t

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def red_alert?(%Context{} = cxt) do
    cxt
    |> Context.current_order
    |> Order.is(:red_alert)
  end

  def vector?(%Context{} = cxt) do
    cxt
    |> Context.current_order
    |> Order.is(:vector)
  end

  def jump_out?(%Context{} = cxt) do
    cxt
    |> Context.current_order
    |> Order.is(:jump_out)
  end

end
