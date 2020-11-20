defmodule Chukinas.Skies.Game.Hit do

  @type t :: %{
    type: atom(),
    value: integer()
  }

  @spec rand() :: t()
  def rand() do
    %{
      type: Enum.random([
        :cockpit,
        :wing,
        :fuel,
        :rudder,
        :engine,
        :fuselage,
        :elevator
      ]),
      value: Enum.random(2..9)
    }
  end

end
