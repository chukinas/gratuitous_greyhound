defmodule Statechart.TestSupport.NestedState do

  defmodule Machine do
    use Statechart, :machine
    # TODO There should be a compile time error for not incl this default state
    default_state :on
    state :on do
      default_state :green
      state :green do
        on :cycle, do: :yellow
      end
      state :yellow do
        on :cycle, do: :red
      end
      state :red do
        on :cycle, do: :green
      end
    end
  end


end
