defmodule SunsCore.Machine.Setup do

  use Statechart, :machine

  defmachine external_states: ~w/playing/a do

    alias SunsCore.Event.Setup, as: SetupEvent

    defstate :adding_players, default: true do
      SetupEvent.AddPlayer >>> :adding_players
      SetupEvent.ConfirmPlayers >>> :setting_scale
    end

    defstate :setting_scale do
      SetupEvent.SetScale >>> :adding_tables
    end

    #defstate :choosing_administrator do
    #  SetAdministrator >>> :adding_tables
    #end

    defstate :adding_tables do
      SetupEvent.AddTable >>> :adding_objectives
    end

    defstate :adding_objectives do
      SetupEvent.AddObjective >>> :playing
    end

  end

end
