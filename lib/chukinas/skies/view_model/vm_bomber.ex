defmodule Chukinas.Skies.ViewModel.Bomber do

  alias Chukinas.Skies.Game.Bomber, as: G_Bomber

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :x, integer()
    field :y, integer()
    field :id, String.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build(G_Bomber.t()) :: t()
  def build(%G_Bomber{location: {x, y}} = bomber) do
    %__MODULE__{
      x: x,
      y: y,
      id: G_Bomber.to_client_id(bomber)
    }
  end

end
