alias Chukinas.Geometry.{Size, Position, Pose}
alias Chukinas.PositionOrientationSize, as: POS

defmodule POS do

  require Position.Guard
  import Position.Guard

  defmacro __using__(_opts) do
    quote do
      require Position.Guard
      import Position.Guard
      require POS
      import POS
      use Chukinas.TypedStruct
    end
  end


  # *** *******************************
  # *** POSITION

  @type position_type :: Position.t()
  @type position_list :: [position_type]

  defdelegate position(term), to: Position, as: :new
  defdelegate position(a, b), to: Position, as: :new

  defdelegate position_from_size(size), to: Position, as: :from_size

  # TODO this doesn't belong here
  defdelegate position_to_vertex(position), to: Position, as: :to_vertex

  defdelegate position_to_tuple(position), to: Position, as: :to_tuple

  defdelegate position_add(has_position, term), to: Position, as: :add
  defdelegate position_add_x(has_position, scalar), to: Position, as: :add_x
  defdelegate position_add_y(has_position, scalar), to: Position, as: :add_y

  defdelegate position_subtract(position, scalar), to: Position, as: :subtract

  defdelegate position_multiply(position, scalar), to: Position, as: :multiply

  defdelegate position_divide(position, scalar), to: Position, as: :divide

  defdelegate position_min_max(items_with_position), to: Position, as: :min_max

  # *** *******************************
  # *** SIZE

  def size_new(a, b) when has_position(a) and has_position(b) do
    Size.new(a, b)
  end
  defdelegate size_new(size), to: Size, as: :new
  defdelegate size_new(a, b), to: Size, as: :new

  defdelegate size_multiply(size, scalar), to: Size, as: :multiply

  defdelegate width(size), to: Size

  defdelegate height(size), to: Size

  # *** *******************************
  # *** ANGLE

  def angle(%{angle: value}), do: value

  # *** *******************************
  # *** POSE

  defdelegate pose(term), to: Pose, as: :new

  defdelegate pose_origin(), to: Pose, as: :origin

  def pose_into(pose, poseable_item)
  when has_pose(pose)
  and has_pose(poseable_item) do
    Pose.put_pose(poseable_item, pose)
  end

  def pose_to_keywords(pose) do
    pose
    |> pose()
    |> Map.from_struct
    |> Enum.into([])
  end

  # TODO there should be a better API
  def opts_convert_pose(opts) do
    case Keyword.pop(opts, :pose) do
      {nil, _} ->
        opts
      {pose, opts} ->
        opts
        |> Keyword.merge(pose |> pose_to_keywords)
    end
  end

end
