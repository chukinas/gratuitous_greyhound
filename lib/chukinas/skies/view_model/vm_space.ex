defmodule Chukinas.Skies.ViewModel.Space do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :x, integer()
    field :y, integer()
    field :lethal_level, any()
  end

  # *** *******************************
  # *** BUILD

  @spec build(Space.t()) :: t()
  def build(space) do
    %__MODULE__{x: space.x, y: space.y, lethal_level: space.lethal_level}
  end
end
