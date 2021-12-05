defmodule SunsCore.Machine.MovementStep do

  use Statechart, :machine

  defmachine external_states: ~w/passive_attacks_step/a do

    alias SunsCore.Context
    alias SunsCore.Event

    # *** *******************************
    # *** STATES

    defstate :basic_move, default: true do
      Event.MovementStep.Move >>> :goto_vector_movement?
    end

    defstate :vector_move do
      Event.MovementStep.Move >>> :passive_attacks_step
    end

    defstate :red_alert do
      RemoveDamage >>> :passive_attacks_step
    end

    # *** *******************************
    # *** TYPES

    decision :goto_vector_movement?,
      &Context.Order.vector?/1,
      if_true: :vector_move,
      else: :goto_red_alert?

    decision :goto_red_alert?,
      &Context.Order.red_alert?/1,
      if_true: :red_alert,
      else: :passive_attacks_step

  end

end
