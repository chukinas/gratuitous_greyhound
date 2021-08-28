defmodule SunsCore.Event.CommandPhase do

  use SunsCore.Event, :placeholders

  #placeholder_event SetAdministrator

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.CommandPhase.AssignCmd
      alias SunsCore.Event.CommandPhase.RollOffForInitiative
    end
  end

end
