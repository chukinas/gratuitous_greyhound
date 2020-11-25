defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.ViewModel.GroupPawn

  # *** *******************************
  # *** TYPES

  defstruct [
    :title,
    :id,
    :pawns,
  ]

  @type direction :: G_Box.position()

  @type t :: %__MODULE__{
    title: String.t(),
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
    {_, _, _, id} = box.id |> G_Box.id_to_strings()
    %__MODULE__{
      title: id,
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

  # TODO is this direction type spec correct? it includes not ented
  @spec in_position?(t(), direction()) :: boolean()
  def in_position?(%__MODULE__{id: id}, position) do
    position == id
    |> String.split("_")
    |> Enum.at(0)
    |> String.to_atom()
  end

end
