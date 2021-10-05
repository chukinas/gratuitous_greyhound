defmodule SunsCore.Event.Setup do

  use SunsCore.Event, :placeholders

  placeholder_event SetAdministrator

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Event.Setup.AddPlayer
      alias SunsCore.Event.Setup.ConfirmPlayers
      alias SunsCore.Event.Setup.SetScale
      alias SunsCore.Event.Setup.SetAdministrator
      alias SunsCore.Event.Setup.AddTable
      alias SunsCore.Event.Setup.AddObjective
    end
  end

end
