defmodule SunsCore.Machine do

  use Statechart, :machine

  use SunsCore.Event.CommandPhase
  use SunsCore.Event.TacticalPhase
  alias Statechart.Machine
  alias Statechart
  alias SunsCore.Context

  defmachine do

    initial_context Context.new()

    defpartial :setup, SunsCore.Machine.Setup, default: true

    defstate :playing do

      defstate :start_turn, default: true do
        on_enter &Context.incr_turn_number/1
        autotransition :command_phase
      end

      defpartial :command_phase, SunsCore.Machine.CommandPhase

      defpartial :jump_phase, SunsCore.Machine.JumpPhase

      decision :any_battlegroups_still_unactivated?,
        &TacticalPhase.any_battlegroups_still_unactivated?/1,
        if_true: :awaiting_command,
        else: :active_attacks_step

      defstate :tactical_phase do

        defstate :awaiting_order, default: true do
          IssueOrder >>> :movement_step
        end
        defstate :movement_step do
          Move >>> :active_attacks_step
        end

        decision :goto_remove_dmg?,
          &Context.Order.red_alert?/1,
          if_true: :removing_damage,
          else: :goto_vector_movement?
        defstate :removing_damage do
          RemoveDamage >>> :passive_attacks_step
        end

        decision :goto_vector_movement?,
          &Context.Order.vector?/1,
          if_true: :vector_movement,
          else: :passive_attacks_step
        defstate :vector_movement do
          Move >>> :passive_attacks_step
        end

        defpartial :passive_attacks_step, SunsCore.Machine.PassiveAttacksStep

        defpartial :jump_out_step, SunsCore.Machine.JumpOutStep

        defpartial :active_attacks_step, SunsCore.Machine.ActiveAttacksStep

        defstate :scan_step do
          Skip >>> :end_activation
          Scan >>> :end_activation
        end

        defstate :end_activation do
        end

      end

      defstate :end_phase do
        # TODO unactivate all ships
      end

    end

  end

  def snapshot(%Machine{} = machine) do
    %Context{} = snapshot = Machine.context(machine)
    snapshot
  end

  def snapshot(mission, key) do
    mission
    |> snapshot
    |> Map.fetch!(key)
  end

end
