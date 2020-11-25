defmodule Chukinas.Skies.ViewModel.Positions do

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

  @spec build([G_Box.t()], [G_FighterGroup.t()]) :: t()
  def build(boxes, all_groups) do
    boxes = VM_Box.build_boxes(boxes, all_groups)
    %__MODULE__{
      nose: filter_boxes(boxes, :nose),
      left: filter_boxes(boxes, :left),
      right: filter_boxes(boxes, :right),
      tail: filter_boxes(boxes, :tail),
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec filter_boxes([VM_Box.t()], direction()) :: [VM_Box.t()]
  defp filter_boxes(boxes, desired_position) do
    Enum.filter(boxes, &VM_Box.in_position?(&1, desired_position))
  end

end

# TODO move to new file
defmodule Chukinas.Skies.ViewModel.GroupPawn do

  alias Chukinas.Skies.Game.FighterGroup, as: G_FighterGroup

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :fighter_count,
  ]

  @type t :: %__MODULE__{
    id: integer(),
    fighter_count: integer(),
  }


  # *** *******************************
  # *** BUILD

  @spec build(G_FighterGroup.t()) :: t()
  def build(group) do
    %__MODULE__{
      id: group.id,
      fighter_count: Enum.count(group.fighter_ids),
    }
  end

end

# TODO move to new file
defmodule Chukinas.Skies.ViewModel.GroupPawns do

  alias Chukinas.Skies.Game.Box
  alias Chukinas.Skies.ViewModel.GroupPawn

  # *** *******************************
  # *** TYPES

  @type t :: %{Box.id() => GroupPawn.t()}

  # *** *******************************
  # *** BUILD

  @spec build([G_FighterGroup.t()]) :: [t()]
  def build(groups) do
    groups
    |> Enum.map(&GroupPawn.build/1)
  end

end
