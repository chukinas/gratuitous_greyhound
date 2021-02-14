alias Chukinas.Geometry.{Point, Rect}
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
      arena_rect = Rect.new(Point.origin(), Point.new(arena.size))
      arena_rect |> Rect.contains?(pose)
    end
  end

end
