defmodule Chukinas.Skies.Game.Escort do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
  end

  # *** *******************************
  # *** NEW

  @spec new(integer) :: t()
  def new(id) do
    %__MODULE__{id: id}
  end

end
