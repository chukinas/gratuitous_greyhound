defmodule Chukinas.Skies.Game.EscortStation do

  # *** *******************************
  # *** TYPES

  # TODO is this used in vm?
  @type id() :: :forward | :abovetrailing | :belowtrailing

  use TypedStruct

  typedstruct enforce: true do
    field :id, id()
  end

  # *** *******************************
  # *** API

  # TODO rename ids?
  @spec box_names :: [id()]
  def box_names(), do: [:forward, :abovetrailing, :belowtrailing]

end
