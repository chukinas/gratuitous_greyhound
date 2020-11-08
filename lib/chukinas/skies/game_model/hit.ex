defmodule Chukinas.Skies.Game.Hit do

  def rand() do
    %{
      type: Enum.random(
        :cockpit,
        :wing,
        :fuel,
        :rudder,
        :engine,
        :fuselage,
        :elevator
      ),
      value: Enum.random(2..9)
    }
  end

end
