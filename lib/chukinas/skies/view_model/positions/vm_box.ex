defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Game.Box, as: G_Box

  # *** *******************************
  # *** TYPES

  defstruct [
    :position,
    :box_type,
    :altitude,
    :id
  ]

  @type direction :: G_Box.specific_direction()

  @type t :: %__MODULE__{
    position: String.t(),
    box_type: String.t(),
    altitude: String.t(),
    id: String.t(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(G_Box.t()) :: t()
  def build(box) do
    {position, box_type, altitude, id} = box.location |> G_Box.to_strings()
    %__MODULE__{
      position: position,
      box_type: box_type,
      altitude: altitude,
      id: id
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec in_position?(t(), direction()) :: boolean()
  def in_position?(%__MODULE__{position: actual_position}, position) do
    actual_position == Atom.to_string(position)
  end

end
