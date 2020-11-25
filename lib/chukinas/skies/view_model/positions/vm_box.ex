defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.ViewModel.GroupPawn

  # *** *******************************
  # *** TYPES

  defstruct [
    :position,
    :box_type,
    :altitude,
    :id,
    :pawns,
  ]

  @type direction :: G_Box.position()

  @type t :: %__MODULE__{
    position: String.t(),
    box_type: String.t(),
    altitude: String.t(),
    id: String.t(),
    pawns: [GroupPawn.t()],
  }

  # *** *******************************
  # *** BUILD

  @spec build(G_Box.t(), [G_FighterGroup.t()]) :: t()
  def build(box, all_groups) do
    group_pawns = all_groups
    |> Enum.filter(fn group -> group.current_location == box.id end)
    |> Enum.map(&GroupPawn.build/1)
    {position, box_type, altitude, id} = box.id |> G_Box.id_to_strings()
    %__MODULE__{
      position: position,
      box_type: box_type,
      altitude: altitude,
      id: id,
      pawns: group_pawns,
    }
  end

  @spec build_boxes([G_Box.t()], [G_FighterGroup.t()]) :: [t()]
  def build_boxes(boxes, all_groups) do
    boxes |> Enum.map(&build(&1, all_groups))
  end

  # *** *******************************
  # *** HELPERS

  @spec in_position?(t(), direction()) :: boolean()
  def in_position?(%__MODULE__{position: actual_position}, position) do
    actual_position == Atom.to_string(position)
  end

end
