defmodule Statechart.TestSupport.PartialMachine do

  use Statechart, :machine

  defmodule Driving do
    defstruct []
  end

  defmachine external_states: [:mars] do

    alias Statechart.TestSupport.PartialMachine.Driving

    defstate :philly, default: true do
      Driving >>> :new_york
    end

    defstate :new_york do
      :fly_on_rocket_ship >>> :mars
    end

  end

end


defmodule Statechart.TestSupport.PartialAggregatorMachine do

  use Statechart, :machine
  alias Statechart.TestSupport.PartialMachine
  require PartialMachine

  defmachine do

    defstate :mars, default: true do
      :go_home >>> :philly
    end

    defpartial :earth, PartialMachine

  end

end
