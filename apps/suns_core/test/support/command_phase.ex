defmodule SunsCore.TestSupport.CommandPhase do

  use SunsCore.Event.CommandPhase
  alias SunsCore.TestSupport.Helpers
  alias SunsCore.Mission.Cmd

  def assign_cmd(machine) do
    AssignCmd.new(1, Cmd.new(0, 3, 2))
    |> Helpers.apply_transition(machine)
  end

  def roll_off_for_initiative(machine) do
    RollOffForInitiative.new()
    |> Helpers.apply_transition(machine)
  end

end
