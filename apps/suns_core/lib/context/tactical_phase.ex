defmodule SunsCore.Context.TacticalPhase do

  alias SunsCore.Context

  # *** *******************************
  # *** TYPES

  @type t :: Context.t

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def multiplayer?(%Context{} = cxt) do
    Context.player_count(cxt) in 2..4
  end

  def any_battlegroups_still_unactivated?(%Context{} = _cxt) do
    # TODO implement
    false
  end

end
