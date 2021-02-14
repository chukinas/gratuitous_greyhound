alias Chukinas.Geometry.{Point, Position}
alias Chukinas.Dreadnought.{MoveSegment, Arena}

defmodule Arena do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :size, Point.t()
  end

  # *** *******************************
  # *** NEW

  def new(size_x, size_y) do
    size = Point.new(size_x, size_y)
    %__MODULE__{size: size}
  end

  # *** *******************************
  # *** API

  # TODO this should be in MoveSegment
  def get_inbounds_checker(arena) do
    fn segments ->
      pose = segments |> List.first() |> MoveSegment.get_start_pose()
      arena |> contains?(pose)
    end
  end

  # TODO create position guard `has_position` or `is_position`?
  def contains?(%__MODULE__{size: size}, position) do
    Position.gte(position, Point.origin()) && Position.lte(position, size)
  end

  # *** *******************************
  # *** PRIVATE

  # defp final_segment_ends_inbounds?(arena, segments) when is_list(segments) do
  #   segments
  #   |> List.last()
  #   |> in_bounds?(arena)
  # end

  # # TODO be more consistent with param ordering. Arena should prob come first.
  # defp in_bounds?(%MoveSegment{} = segment, %__MODULE__{size: size}) do
  #   size |> IO.inspect()
  #   segment |> IO.inspect()
  #   end_pose = MoveSegment.get_end_pose(segment)
  #   # TODO arena should come first
  #   (Position.gte(end_pose, Point.origin()) && Position.lte(end_pose, size)
  #   )    |> IO.inspect(label: "in bounds?")
  # end

end
