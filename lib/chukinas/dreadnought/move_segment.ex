alias Chukinas.Dreadnought.{MoveSegment}
alias Chukinas.Geometry.{Point, Pose}

defmodule MoveSegment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :start_pose, Pose.t()
    field :end_pose, Pose.t()
    field :position, Point.t()
    field :svg_path, String.t()
    field :svg_viewbox, String.t()
  end

  # *** *******************************
  # *** API

  def get_start_pose(segment) do
    segment.start_pose
  end

  def get_end_pose(segment) do
    segment.end_pose
  end

end
