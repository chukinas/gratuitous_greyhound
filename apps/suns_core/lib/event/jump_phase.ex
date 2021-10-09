defmodule SunsCore.Event.JumpPhase do

  use SunsCore.Event, :placeholders
  alias SunsCore.Mission.Context
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.TurnOrderTracker
  alias SunsCore.RandomNumberGenerator, as: Num

  # *** *******************************
  # *** TYPES

  @type t :: Context.t

  placeholder_event Skip
  placeholder_event ChooseStartPlayer

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.JumpPhase.DeployBattlegroup
      alias SunsCore.Event.JumpPhase.DeployJumpPoint
      alias SunsCore.Event.JumpPhase.RequisitionBattlegroup
      alias SunsCore.Event.JumpPhase.Skip
      # TODO this should probably be more general?
      # It'll be used in Tac Phase too
      alias SunsCore.Event.JumpPhase.ChooseStartPlayer
      alias unquote(__MODULE__)
    end
  end

  # *** *******************************
  # *** REDUCERS

  @spec init_and_put_turn_order_tracker(Context.t) :: Context.t
  def init_and_put_turn_order_tracker(%Context{} = cxt) do
    tracker =
      cxt
      |> Context.helms
      |> TurnOrderTracker.new(Num.new())
    Context.set(cxt, tracker)
  end

  @spec goto_next_player(Context.t) :: Context.t
  def goto_next_player(cxt) do
    {_player_id, tracker} =
      cxt
      |> Context.turn_order_tracker
      |> TurnOrderTracker.get_and_update_next_player_id
    Context.set(cxt, tracker)
  end

  # *** *******************************
  # *** CONVERTERS

  def any_jump_cmd?(%Context{} = cxt) do
    cxt
    |> Context.helms
    |> Enum.any?(&Helm.has_jump_cmd?/1)
  end

  def multiplayer?(%Context{} = cxt) do
    Context.player_count(cxt) in 2..4
  end

end
