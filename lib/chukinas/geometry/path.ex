alias Chukinas.Geometry.{Path, PathLike, Straight, Turn}

defmodule Path do

  # *** *******************************
  # *** TYPES

  @type t() :: PathLike.t()

  def new(%{pose: pose, length: length, angle: angle}) do
    new_turn(pose, length, angle)
  end
  def new(%{pose: pose, length: length}) do
    new_straight(pose, length)
  end
  def new(keyword_list) when is_list(keyword_list) do
    keyword_list |> Enum.into(%{}) |> new()
  end
  defdelegate new_straight(x, y, angle, length), to: Straight, as: :new
  defdelegate new_straight(start_pose, length), to: Straight, as: :new
  defdelegate new_turn(start_pose, length, angle), to: Turn, as: :new
  defdelegate get_start_pose(path), to: PathLike, as: :pose_start
  defdelegate get_end_pose(path), to: PathLike, as: :pose_end
  defdelegate get_bounding_rect(path), to: PathLike, as: :get_bounding_rect
end
