defmodule SunsCore.Machine.JumpOutStep do

  use Statechart, :machine

  defmachine external_states: ~w/any_battlegroups_still_unactivated? active_attacks_step/a do

    alias SunsCore.Context
    alias SunsCore.Event

    default_to :goto_stay_in_jump_out_step?

    decision :goto_stay_in_jump_out_step?,
      &Context.Order.jump_out?/1,
      if_true: :awaiting_command,
      else: :active_attacks_step

    defstate :awaiting_command do
      Event.Skip >>> :active_attacks_step
      Event.JumpOutStep.JumpOut >>> :any_battlegroups_still_unactivated?
    end

  end

end
