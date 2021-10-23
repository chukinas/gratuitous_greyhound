defmodule SunsCore.Machine.ActiveAttacksStep do

  use Statechart, :machine

  defmachine external_states: ~w/scan_step end_phase/a do

    alias SunsCore.Context
    alias SunsCore.Event

    default_to :engaged_and_valid?

    decision :engaged_and_valid?,
      &Context.ActiveAttacksStep.engaged_and_valid?/1,
      if_true: :eval_attacks,
      else: :selecting_targets

    defstate :selecting_targets do
      # TODO rename to SelectTarget
      Event.ActiveAttacksStep.AttackEngagedTarget >>> :end_phase
    end

    defstate :eval_attacks do
      on_enter &Context.ActiveAttacksStep.eval_attacks/1
      autotransition :casualties_remaining?
    end

    decision :casualties_remaining?,
      &Context.ActiveAttacksStep.casualties_remaining?/1,
      if_true: :removing_casualties,
      else: :scan_step

    defstate :removing_casualties do
      Event.ActiveAttacksStep.RemoveCasualties >>> :casualties_remaining?
    end

  end

end
