defmodule Chukinas.Skies.Game.EscortStation do

  # *** *******************************
  # *** TYPES

  @type id() :: :forward | :abovetrailing | :belowtrailing

  use TypedStruct

  typedstruct enforce: true do
    field :id, id()
  end

  # *** *******************************
  # *** API

  @spec ids :: [id()]
  def ids(), do: [:forward, :abovetrailing, :belowtrailing]

end
