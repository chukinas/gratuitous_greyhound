defmodule Chukinas.Skies.ViewModel.Boxes do

  alias Chukinas.Skies.Game.Box, as: GBox
  alias Chukinas.Skies.Game.FighterGroups, as: GFighterGroup
  alias Chukinas.Skies.ViewModel.Box, as: VBox

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :nose, [VBox.t()]
    field :left, [VBox.t()]
    field :right, [VBox.t()]
    field :tail, [VBox.t()]
    field :notentered, VBox.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build([GBox.t()], GFighterGroup.t()) :: t()
  def build(g_boxes, g_fighter_groups) do
    boxes = g_boxes
    |> Enum.map(&VBox.build_fighter_box(&1, g_fighter_groups))
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

  @spec filter_boxes([VBox.t()], GBox.box_group()) :: [VBox.t()]
  defp filter_boxes(boxes, box_group) do
    Enum.filter(boxes, &in_box_group?(&1, box_group))
  end

  @spec find_box([VBox.t()], GBox.box_group()) :: VBox.t()
  defp find_box(boxes, :notentered) do
    Enum.find(boxes, &in_box_group?(&1, :notentered))
  end

  @spec in_box_group?(VBox.t(), GBox.box_group()) :: boolean()
  defp in_box_group?(%VBox{uiid: uiid}, box_group) do
    String.starts_with?(
      uiid,
      Atom.to_string(box_group)
    )
  end

end
