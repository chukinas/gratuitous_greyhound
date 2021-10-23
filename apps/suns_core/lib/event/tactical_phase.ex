defmodule SunsCore.Event.TacticalPhase do

  alias SunsCore.Context

  # *** *******************************
  # *** TYPES

  @type t :: Context.t

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.TacticalPhase.IssueOrder
      alias SunsCore.Event.TacticalPhase.Move
      alias SunsCore.Event.ActiveAttacksStep.AttackEngagedTarget
      alias unquote(__MODULE__)
    end
  end

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
