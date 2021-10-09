defmodule SunsCore.StateMachine do

  use Statechart, :machine
  use SunsCore.Event.Setup
  use SunsCore.Event.CommandPhase
  use SunsCore.Event.JumpPhase
  alias Statechart.Machine
  alias Statechart
  alias SunsCore.Mission.Context
  alias SunsCore.Mission.Context, as: S

  defmachine do

    initial_context Context.new()

    defstate :setup, default: true do
      defstate :adding_players, default: true do
        on AddPlayer, do: :adding_players
        on ConfirmPlayers, do: :setting_scale
      end
      defstate :setting_scale do
        on SetScale, do: :adding_tables
      end
      #defstate :choosing_administrator do
      #  on SetAdministrator, do: :adding_tables
      #end
      defstate :adding_tables do
        on AddTable, do: :adding_objectives
      end
      defstate :adding_objectives do
        on AddObjective, do: :playing
      end
    end

    defstate :playing do

      defstate :start_turn, default: true do
        on_enter &S.incr_turn_number/1
        autotransition :command_phase
      end

      defstate :command_phase do
        defstate :assigning_cmd, default: true do
          on AssignCmd, do: :determining_initiative
        end
        defstate :determining_initiative do
          on RollOffForInitiative, do: :jump_phase
        end
      end

      defstate :jump_phase do
        default_to :play_phase_or_exit?

        decision :play_phase_or_exit?,
          &JumpPhase.any_jump_cmd?/1,
          if_true: :init_turn_order_tracker,
          else: :tactical_phase
        defstate :init_turn_order_tracker do
          on_enter &JumpPhase.init_and_put_turn_order_tracker/1
          autotransition :need_to_choose_start_player?
        end

        decision :need_to_choose_start_player?,
          &JumpPhase.multiplayer?/1,
          if_true: :choosing_start_player,
          else: :maybe_next_player_turn
        defstate :choosing_start_player do
          on ChooseStartPlayer, do: :maybe_next_player_turn
        end

        decision :maybe_next_player_turn,
          &JumpPhase.any_jump_cmd?/1,
          if_true: :player_turn,
          else: :tactical_phase
        defstate :player_turn do
          on_enter &JumpPhase.goto_next_player/1
          defstate :main, default: true do
            on Skip, do: :maybe_next_player_turn
            on DeployJumpPoint, do: :maybe_next_player_turn
            on RequisitionBattlegroup, do: :deploying_battlegroup
          end
          defstate :deploying_battlegroup do
            on DeployBattlegroup, do: :maybe_next_player_turn
          end
        end
      end

      defstate :tactical_phase do
        defstate :issue_orders, default: true do
        end
        defstate :movement_step do
        end
        defstate :passive_attacks_step do
        end
        defstate :jump_out_step do
        end
        defstate :active_attacks_step do
        end
        defstate :scan_step do
        end
      end
      defstate :end_phase do
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
