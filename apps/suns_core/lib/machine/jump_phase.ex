defmodule SunsCore.Machine.JumpPhase do

  use Statechart, :machine

  defmachine external_states: ~w/tactical_phase/a do

    alias SunsCore.Context
    alias SunsCore.Event

    default_to :play_phase_or_exit?

    decision :play_phase_or_exit?,
      &Context.JumpPhase.any_jump_cmd?/1,
      if_true: :init_turn_order_tracker,
      else: :tactical_phase
    defstate :init_turn_order_tracker do
      on_enter &Context.JumpPhase.init_and_put_turn_order_tracker/1
      autotransition :need_to_choose_start_player?
    end

    decision :need_to_choose_start_player?,
      &Context.JumpPhase.multiplayer?/1,
      if_true: :choosing_start_player,
      else: :maybe_next_player_turn
    defstate :choosing_start_player do
      Event.JumpPhase.ChooseStartPlayer >>> :maybe_next_player_turn
    end

    decision :maybe_next_player_turn,
      &Context.JumpPhase.any_jump_cmd?/1,
      if_true: :player_turn,
      else: :tactical_phase
    defstate :player_turn do
      on_enter &Context.JumpPhase.goto_next_player/1
      defstate :main, default: true do
        Event.JumpPhase.Skip >>> :maybe_next_player_turn
        Event.JumpPhase.DeployJumpPoint >>> :maybe_next_player_turn
        Event.JumpPhase.RequisitionBattlegroup >>> :deploying_battlegroup
      end
      defstate :deploying_battlegroup do
        Event.JumpPhase.DeployBattlegroup >>> :maybe_next_player_turn
      end
    end

  end

end
