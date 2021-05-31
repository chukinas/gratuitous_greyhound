alias Chukinas.Geometry.{Pose, Position}

defmodule Pose do

  require Position
  use Chukinas.Math
  use Chukinas.TypedStruct

  typedstruct do
    pose_fields()
  end

  # *** *******************************
  # *** NEW

  # arity-1

  def new(%{x: x, y: y, angle: angle}), do: new(x, y, angle)

  def new(%__MODULE__{} = pose), do: pose

  def new({x, y, angle}), do: new(x, y, angle)

  # arity-2

  def new(%{x: x, y: y}, angle), do: new(x, y, angle)

  def new({x, y}, angle), do: new(x, y, angle)

  # arity-3

  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: angle
    }
  end

  # Helpers

  def origin(), do: new(0, 0, 0)

  # *** *******************************
  # *** GETTERS

  def angle(%{angle: angle}), do: angle

  def flip(%{angle: angle} = pose) do
    %__MODULE__{pose | angle: angle + 180}
  end

  def tuple(%{x: x, y: y, angle: angle}), do: {x, y, angle}

  # *** *******************************
  # *** SETTERS

  def put_angle(pose, angle), do: %__MODULE__{pose | angle: angle}

  # TODO this is in the wrong place
  def put_pose(poseable_item, pose) when is_struct(poseable_item) do
    pose = new(pose) |> Map.from_struct
    Map.merge(poseable_item, pose)
  end

  # *** *******************************
  # *** API

  def rotate(%__MODULE__{} = pose, angle) do
    %{pose | angle: normalize_angle(pose.angle + angle)}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    require IOP
    def inspect(pose, opts) do
      concat [
        IOP.color("#Pose<"),
        IOP.doc(pose.x |> round),
        ", ",
        IOP.doc(pose.y |> round),
        " ∠ ",
        IOP.doc(round(pose.angle)),
        "°",
        IOP.color(">")
      ]
    end
  end

end
