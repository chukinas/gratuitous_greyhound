defmodule SunsCore.Context.ActiveAttacksStep do

  alias SunsCore.Context

  @type t :: Context.t

  alias SunsCore.Context

  # *** *******************************
  # *** REDUCERS

  def eval_attacks(%Context{} = cxt) do
    # TODO impl
    cxt
  end

  # *** *******************************
  # *** CONVERTERS

  def casualties_remaining?(%Context{} = _cxt) do
    # TODO impl
    false
  end

  def engaged_and_valid?(%Context{} = _cxt) do
    # TODO implement
    false
  end

end
