defmodule SunsCore.Machine.CommandPhase do

  use Statechart, :machine

  defmachine external_states: ~w/jump_phase/a do

    alias SunsCore.Event

    defstate :assigning_cmd, default: true do
      Event.CommandPhase.AssignCmd >>> :determining_initiative
    end

    defstate :determining_initiative do
      Event.CommandPhase.RollOffForInitiative >>> :jump_phase
    end

  end

end
