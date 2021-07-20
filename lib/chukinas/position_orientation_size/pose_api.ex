defmodule Chukinas.PositionOrientationSize.PoseApi do

  alias Chukinas.PositionOrientationSize.Pose

  # *** *******************************
  # *** CONSTRUCTORS

  def pose_from_position(%{x: x, y: y}, angle \\ 0), do: Pose.new(x, y, angle)

  # TODO move to LinearAlgebra as vector_to_pose
  def pose_from_vector({x, y}, angle \\ 0), do: Pose.new(x, y, angle)

  def pose_from_map(%{x: x, y: y, angle: angle}), do: Pose.new(x, y, angle)
  def pose_from_map(%Pose{} = pose), do: pose

  defdelegate pose_new(x, y, angle), to: Pose, as: :new

  def pose_origin, do: Pose.new(0, 0, 0)

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
