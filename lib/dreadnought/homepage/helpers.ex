defmodule Dreadnought.Homepage.Helpers do

  use Dreadnought.Core.Mission.Spec
  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize

  defmacro __using__(_opts) do
    quote do

      @target_player_id 1
      @target_unit_id 1
      @main_player_id 2
      @mission_name "homepage"
      @starting_main_unit_id 2
      @hulls ~w/red_cruiser blue_dreadnought red_destroyer blue_destroyer/a

      def hull_by_unit_id(unit_id) do
        index =
          (unit_id - @starting_main_unit_id)
          |> rem(Enum.count(@hulls))
        Enum.at(@hulls, index)
      end

    end
  end

end
