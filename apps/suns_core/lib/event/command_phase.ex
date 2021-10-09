defmodule SunsCore.Event.CommandPhase do

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.CommandPhase.AssignCmd
      alias SunsCore.Event.CommandPhase.RollOffForInitiative
    end
  end

end
