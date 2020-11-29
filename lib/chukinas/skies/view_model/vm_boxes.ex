defmodule Chukinas.Skies.ViewModel.Boxes do

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
    :notentered,
  ]

  @type t :: %__MODULE__{
    nose: [VM_Box.t()],
    left: [VM_Box.t()],
    right: [VM_Box.t()],
    tail: [VM_Box.t()],
    notentered: VM_Box.t(),
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
      notentered: find_box(boxes, :notentered),
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec filter_boxes([VM_Box.t()], G_Box.box_group()) :: [VM_Box.t()]
  defp filter_boxes(boxes, box_group) do
    Enum.filter(boxes, &in_box_group?(&1, box_group))
  end

  @spec find_box([VM_Box.t()], G_Box.box_group()) :: VM_Box.t()
  defp find_box(boxes, :notentered) do
    Enum.find(boxes, &in_box_group?(&1, :notentered))
  end

  @spec in_box_group?(VM_Box.t(), G_Box.box_group()) :: boolean()
  defp in_box_group?(%VM_Box{id: id}, box_group) do
    String.starts_with?(
      id,
      Atom.to_string(box_group)
    )
  end

end
