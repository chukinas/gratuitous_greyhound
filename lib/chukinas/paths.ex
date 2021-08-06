alias Chukinas.Geometry.{Circle}
alias Chukinas.Paths
alias Paths.{Straight, Turn, PathLike}

defmodule Paths do

  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** TYPES

  @type t() :: PathLike.t()

  def path_new(x, y, angle, length, rotation \\ nil) do
    pose = pose_new(x, y, angle)
    case rotation do
      nil ->
        new_straight(pose, length)
      angle when is_number(angle) ->
        new_turn(pose, length, rotation)
    end
  end

    # TODO remove these
  def new(%{pose: pose, length: length, angle: angle}) do
    new_turn(pose, length, angle)
  end
  def new(%{pose: pose, length: length}) do
    new_straight(pose, length)
  end
  def new(keyword_list) when is_list(keyword_list) do
    keyword_list |> Enum.into(%{}) |> new()
  end
  def put_pose(path, pose), do: %{path | pose: pose}

  defdelegate new_straight(x, y, angle, length), to: Straight, as: :new

  def straight_new(start_pose, length), do: Straight.new(start_pose, length)

  defdelegate new_straight(start_pose, length), to: Straight, as: :new
  defdelegate new_turn(start_pose, length, angle), to: Turn, as: :new
  defdelegate get_start_pose(path), to: PathLike, as: :pose_start
  defdelegate get_end_pose(path), to: PathLike, as: :pose_end

  def pose_at_start(path), do: path |> get_start_pose

  def pose_at_end(path), do: path |> get_end_pose

  def rotation_direction(turn) do
    turn |> Turn.circle |> Circle.rotation_direction
  end

  defdelegate traversal_distance(path), to: PathLike, as: :len

  defdelegate traversal_angle(turn), to: Turn

  def radius(%Turn{} = turn) do
    turn |> Turn.radius
  end

  def position_at_end(path) do
    path
    |> get_end_pose
    |> position_new
  end

  defdelegate exceeds_angle(path, angle), to: PathLike, as: :exceeds_angle
  defdelegate deceeds_angle(path, angle), to: PathLike, as: :deceeds_angle

  def get_connecting_path(start_pose, final_position) do
    case Straight.fetch_connecting_path(start_pose, final_position) do
      :error -> Turn.connecting_path! start_pose, final_position
      {:ok, straight_path} -> straight_path
    end
  end

  def length_from_path(path), do: PathLike.len(path)

end
