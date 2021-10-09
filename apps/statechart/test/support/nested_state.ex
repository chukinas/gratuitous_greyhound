defmodule Statechart.TestSupport.NestedState do

  defmodule Machine do
    use Statechart, :machine
    defmachine do
      default_to :on
      defstate :on do
        defstate :green, default: true do
          on :cycle, do: :yellow
        end
        defstate :yellow do
          on :cycle, do: :red
        end
        defstate :red do
          on :cycle, do: :green
        end
      end
    end
  end


end
