defmodule Chukinas.Skies.ViewModel.Space do

  alias Chukinas.Skies.Game.Space, as: G_Space

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

  @spec build(G_Space.t()) :: t()
  def build(space) do
    %__MODULE__{x: space.x, y: space.y, lethal_level: space.lethal_level}
  end
end
