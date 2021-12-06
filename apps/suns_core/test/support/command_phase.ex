defmodule SunsCore.TestSupport.CommandPhase do

  alias SunsCore.Event.CommandPhase
  alias SunsCore.Mission.Cmd
  alias SunsCore.TestSupport.Helpers

  def command_phase(machine) do
    machine
    |> assign_cmd
    |> roll_off_for_initiative
  end

  def assign_cmd(machine) do
    CommandPhase.AssignCmd.new(1, Cmd.new(0, 3, 2))
    |> Helpers.apply_transition(machine)
  end

  def roll_off_for_initiative(machine) do
    CommandPhase.RollOffForInitiative.new()
    |> Helpers.apply_transition(machine)
  end

end
