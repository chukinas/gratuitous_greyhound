defmodule Chukinas.Skies.ViewModel.Positions do

  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.ViewModel.Box, as: VM_Box

  # *** *******************************
  # *** TYPES

  defstruct [
    :nose,
    :left,
    :right,
    :tail,
  ]

  @type direction :: G_Box.position()

  @type t :: %__MODULE__{
    nose: [VM_Box.t()],
    left: [VM_Box.t()],
    right: [VM_Box.t()],
    tail: [VM_Box.t()],
  }


  # *** *******************************
  # *** BUILD

  @spec build([G_Box.t()]) :: t()
  def build(boxes) do
    boxes = convert_boxes(boxes)
    %__MODULE__{
      nose: filter_boxes(boxes, :nose),
      left: filter_boxes(boxes, :left),
      right: filter_boxes(boxes, :right),
      tail: filter_boxes(boxes, :tail),
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec convert_boxes([G_Box.t()]) :: [VM_Box.t()]
  defp convert_boxes(boxes), do: Enum.map(boxes, &VM_Box.build/1)

  @spec filter_boxes([VM_Box.t()], direction()) :: [VM_Box.t()]
  defp filter_boxes(boxes, desired_position) do
    Enum.filter(boxes, &VM_Box.in_position?(&1, desired_position))
  end

end
