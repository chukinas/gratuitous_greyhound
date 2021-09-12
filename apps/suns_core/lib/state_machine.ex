defmodule SunsCore.StateMachine do

  use Statechart, :machine
  use SunsCore.Event.Setup
  alias Statechart.Machine
  alias Statechart
  alias SunsCore.Mission.Snapshot
  alias SunsCore.Mission.Snapshot, as: S

  # TODO accept an mfa
  initial_context Snapshot.new()

  default_state :setup

  state :setup do
    default_state :adding_players
    state :adding_players do
      # TODO how to do an action-only event?
      on AddPlayer, do: :adding_players
      on ConfirmPlayers, do: :setting_scale
    end
    state :setting_scale do
      on SetScale, do: :adding_tables
    end
    # TODO implement automatic transitions
    #state :choosing_administrator do
    #  on SetAdministrator, do: :adding_tables
    #end
    state :adding_tables do
      on AddTable, do: :adding_objectives
    end
    state :adding_objectives do
      on AddObjective, do: :playing
    end
  end

  state :playing do
    default_state :start_turn
    state :start_turn do
      on_enter &S.incr_turn_number/1
      autotransition :command_phase
    end
    state :command_phase do
      #on_enter &assign_cmd
    end
    state :jump_phase do
    end
    state :tactical_phase do
      state :issue_orders do
      end
      state :movement_step do
      end
      state :passive_attacks_step do
      end
      state :jump_out_step do
      end
      state :active_attacks_step do
      end
      state :scan_step do
      end
    end
    state :end_phase do
    end
  end

  def snapshot(%Machine{} = machine) do
    %Snapshot{} = snapshot = Machine.context(machine)
    snapshot
  end

  def snapshot(mission, key) do
    mission
    |> snapshot
    |> Map.fetch!(key)
  end

end
