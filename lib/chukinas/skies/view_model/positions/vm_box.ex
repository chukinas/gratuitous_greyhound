defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Game.Box, as: G_Box

  # *** *******************************
  # *** TYPES

  defstruct [
    :location,
  ]

  @type direction :: G_Box.specific_direction()

  @type t :: %__MODULE__{
    location: G_Box.location(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(G_Box.t()) :: t()
  def build(box) do
    %__MODULE__{
      location: box.location,
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec in_position?(t(), direction()) :: boolean()
  def in_position?(box, position) do
    {actual_position, _, _} = box.location
    actual_position == position
  end

end
