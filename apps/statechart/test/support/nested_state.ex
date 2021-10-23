defmodule Statechart.TestSupport.NestedState do

  defmodule Machine do
    use Statechart, :machine
    defmachine do
      default_to :on
      defstate :on do
        defstate :green, default: true do
          :cycle >>> :yellow
        end
        defstate :yellow do
          :cycle >>> :red
        end
        defstate :red do
          :cycle >>> :green
        end
      end
    end
  end


end
