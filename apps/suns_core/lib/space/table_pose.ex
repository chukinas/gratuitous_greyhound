defmodule SunsCore.Space.TablePose do

  use Spatial, :pos
  use CollisionDetection.CollidableImpl, :map_to_point

  use TypedStruct
  typedstruct enforce: true do
    field :table_id, pos_integer
    field :x, number
    field :y, number
    field :angle, number
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(pos_integer, number, number, number) :: t
  def new(table_id, x, y, angle) do
    %__MODULE__{
      table_id: table_id,
      x: x,
      y: y,
      angle: angle
    }
  end

  @spec from_pose(pos_integer, Pose.t) :: t
  def from_pose(table_id, %Pose{x: x, y: y, angle: angle}) do
    new(table_id, x, y, angle)
  end

end
