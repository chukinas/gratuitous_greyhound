defmodule Chukinas.Geometry.Path do
  alias Chukinas.Geometry.Path.{Straight}
  alias Chukinas.Geometry.IsPath

  # *** *******************************
  # *** TYPES

  @type t() :: IsPath.t()

  defdelegate new_straight(x, y, angle, length), to: Straight, as: :new
  defdelegate new_straight(start_pose, length), to: Straight, as: :new
  defdelegate get_start_pose(path), to: IsPath, as: :pose_start
  defdelegate get_end_pose(path), to: IsPath, as: :pose_end
  defdelegate get_bounding_rect(path), to: IsPath, as: :get_bounding_rect
end
