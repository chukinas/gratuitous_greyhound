defmodule SunsCore.Event.Play do

  use SunsCore.Event, :placeholders

  placeholder_event SetAdministrator

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.JumpPhase.DeployJumpPoint
      alias SunsCore.Event.JumpPhase.DeployBattlegroup
      alias SunsCore.Event.JumpPhase.RequisitionBattlegroup
    end
  end

end
