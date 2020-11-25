defmodule Chukinas.Skies.ViewModel.Boxes do

  # TODO rename Boxes
  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.Game.FighterGroup, as: G_FighterGroup
  alias Chukinas.Skies.ViewModel.Box, as: VM_Box

  # *** *******************************
  # *** TYPES

  defstruct [
    :nose,
    :left,
    :right,
    :tail,
    :not_entered,
  ]

  @type direction :: G_Box.position()

  @type t :: %__MODULE__{
    nose: [VM_Box.t()],
    left: [VM_Box.t()],
    right: [VM_Box.t()],
    tail: [VM_Box.t()],
    not_entered: VM_Box.t(),
  }


  # *** *******************************
  # *** BUILD

  @spec build([G_Box.t()], [G_FighterGroup.t()]) :: t()
  def build(boxes, all_groups) do
    boxes = VM_Box.build_boxes(boxes, all_groups)
    %__MODULE__{
      nose: filter_boxes(boxes, :nose),
      left: filter_boxes(boxes, :left),
      right: filter_boxes(boxes, :right),
      tail: filter_boxes(boxes, :tail),
      not_entered: find_box(boxes, :not_entered),
    }
  end

  # *** *******************************
  # *** HELPERS

  # TODO I don't think
  @spec filter_boxes([VM_Box.t()], direction()) :: [VM_Box.t()]
  defp filter_boxes(boxes, desired_position) do
    Enum.filter(boxes, &VM_Box.in_position?(&1, desired_position))
  end

  # TODO check spec
  # TODO these two should share a filter function
  @spec find_box([VM_Box.t()], G_Box.id()) :: VM_Box.t()
  defp find_box(boxes, box_id) do
    Enum.find(boxes, fn box -> box.id == G_Box.id_to_string(box_id) end)
  end

end
